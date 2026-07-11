-- INFO: function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Mnemonic: k = "kill (toggle) line diagnostics"
    -- map('<Leader>k', function()
    --   if vim.diagnostic.config().virtual_lines then
    --     vim.diagnostic.config { virtual_lines = false }
    --   else
    --     vim.diagnostic.config { virtual_lines = true }
    --   end
    -- end, '[K]ill (toggle) line diagnostics', 'n')

    -- Mnemonic: l = "toggle line diagnostics floating window"
    map('<Leader>l', function()
      vim.diagnostic.open_float { border = 'single' }
    end, '[L]ine diagnostics', 'n')

    map('<c-]>', vim.lsp.buf.definition, 'Definition', 'n')
    map('?', function()
      vim.lsp.buf.hover { border = 'single' }
    end, 'Documentation', 'n')

    map('gR', vim.lsp.buf.rename, '[R]e[n]ame', 'n')
    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('ga', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    map('gd', vim.lsp.buf.definition, 'Goto Definition', 'n')
    map('gr', vim.lsp.buf.references, 'References', 'n')
    map('gI', vim.lsp.buf.implementation, 'Goto Implementation', 'n')
    map('gy', vim.lsp.buf.type_definition, 'Goto T[y]pe Definition', 'n')
    map('gD', vim.lsp.buf.declaration, 'Goto Declaration', 'n')

    map('K', function()
      return vim.lsp.buf.hover()
    end, 'Hover', 'n')
    map('gK', function()
      return vim.lsp.buf.signature_help()
    end, 'Signature Help', 'n')
    map('<c-k>', function()
      return vim.lsp.buf.signature_help()
    end, 'Signature Help', 'i')

    map('<leader>cr', vim.lsp.buf.rename, 'Rename', 'n')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('\\H', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

---@type table<string, vim.lsp.Config>
local servers = {
  rust_analyzer = {},
  ts_ls = {},
  astro = {},
  hyprls = {},
  cssls = {},
  html = {},
  dockerls = {},
  stylua = {},
  -- nil_ls = { enabled = false },
  -- Nixd is not avaible on mason

  -- Special Lua Config, as recommended by neovim help docs
  lua_ls = {
    on_init = function(client)
      -- client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if
          path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
        then
          return
        end
      end

      client.config.root_dir = vim.fs.dirname(vim.fs.find({
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        'selene.toml',
        'selene.yml',
        '.git',
      }, { upward = true })[1])
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        format = { enable = true }, -- Formatted by stylua
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global, etc.
        globals = {
          'vim',
          'describe',
          'it',
          'assert',
          'stub',
        },
        disable = {
          'duplicate-set-field',
        },
        telemetry = {
          enable = false,
        },
        hint = {
          enable = false,
        },
      },
    },
  },
}

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'nix',
  callback = function(args)
    vim.lsp.start {
      name = 'nixd',
      cmd = { 'nixd' },
      root_dir = vim.fs.root(args.buf, { 'flake.nix', 'default.nix', 'shell.nix', '.git' }) or vim.fn.getcwd(),
      capabilities = require('user.lsp').make_client_capabilities(),
      settings = {
        nixd = {
          nixpkgs = {
            expr = 'import <nixpkgs> { }',
          },
          formatting = {
            command = { 'nixfmt' },
          },
          options = {
            nixos = {
              expr = '(builtins.getFlake ("git+file://" + toString /home/wyspr/Configuration/NixOS/)).nixosConfigurations.ramiel.options',
            },
            -- wrappers = {
            --   expr = '(builtins.getFlake ("git+file://" + toString /home/wyspr/Configuration/NixOS/)).nixosConfigurations.ramiel.config.wrappers',
            -- },
            -- home_manager = {
            --   expr = '(builtins.getFlake (builtins.toString /home/wyspr/Configuration/NixOS/)).nixosConfigurations.ramiel.options.home-manager.users.type.getSubOptions []',
            -- },
          },
        },
      },
    }
  end,
})

-- local map = vim.keymap.set
--
-- map('n', '<leader>cl', function()
--   Snacks.picker.lsp_config()
-- end, { desc = 'Lsp Info' })
--
-- map('n', '<leader>cR', function()
--   Snacks.rename.rename_file()
-- end, { desc = 'Rename File' })
--
-- map('n', ']]', function()
--   Snacks.words.jump(vim.v.count1)
-- end, { desc = 'Next Reference' })
--
-- map('n', '[[', function()
--   Snacks.words.jump(-vim.v.count1)
-- end, { desc = 'Prev Reference' })
--
-- map('n', '<a-n>', function()
--   Snacks.words.jump(vim.v.count1, true)
-- end, { desc = 'Next Reference' })
--
-- map('n', '<a-p>', function()
--   Snacks.words.jump(-vim.v.count1, true)
-- end, { desc = 'Prev Reference' })
