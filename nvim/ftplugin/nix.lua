-- Exit if the language server isn't available
if vim.fn.executable('nil') ~= 1 then
  return
end

local root_files = {
  'flake.nix',
  'default.nix',
  'shell.nix',
  '.git',
}

require('lspconfig').nil_ls.setup {
  settings = {
    formatting = { command = { 'nix fmt' } },
    nix = {
      flake = {
        -- calls `nix flake archive` to put a flake and its output to store
        autoArchive = true,
      },
    },
  },
}

vim.lsp.start {
  name = 'nil_ls',
  cmd = { 'nil' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
}
