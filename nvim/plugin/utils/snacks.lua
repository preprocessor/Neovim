local excluded = {
  'node_modules/',
  'dist/',
  '.next/',
  '.vite/',
  '.git/',
  '.gitlab/',
  'build/',
  'target/',
  'result/',
  'dadbod_ui/tmp/',
  'dadbod_ui/dev/',
  'package-lock.json',
  'pnpm-lock.yaml',
  'yarn.lock',
  'flake.lock',
}

local root_patterns = {
  -- directories
  'client',
  'server',

  -- version control systems
  '_darcs',
  '.hg',
  '.bzr',
  '.svn',
  '.git',

  -- build tools
  'Makefile',
  'CMakeLists.txt',
  'build.gradle',
  'build.gradle.kts',
  'pom.xml',
  'build.xml',

  -- node.js and javascript
  'package.json',
  'package-lock.json',
  'yarn.lock',
  '.nvmrc',
  'gulpfile.js',
  'Gruntfile.js',

  -- python
  'requirements.txt',
  'Pipfile',
  'pyproject.toml',
  'setup.py',
  'tox.ini',

  -- rust
  'Cargo.toml',

  -- go
  'go.mod',

  -- elixir
  'mix.exs',

  -- configuration files
  '.prettierrc',
  '.prettierrc.json',
  '.prettierrc.yaml',
  '.prettierrc.yml',
  '.eslintrc',
  '.eslintrc.json',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintignore',
  '.stylelintrc',
  '.stylelintrc.json',
  '.stylelintrc.yaml',
  '.stylelintrc.yml',
  '.editorconfig',
  '.gitignore',

  -- html projects
  'index.html',

  -- miscellaneous
  'README.md',
  'README.rst',
  'LICENSE',
  'Vagrantfile',
  'Procfile',
  '.env',
  '.env.example',
  'config.yaml',
  'config.yml',
  '.terraform',
  'terraform.tfstate',
  '.kitchen.yml',
  'Berksfile',
}

require('snacks').setup {
  dashboard = require('user.dashboard'),
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = false }, -- we set this in options.lua
  words = { enabled = true },
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  terminal = { enabled = false },
  picker = {
    actions = {
      trouble_open = function(...)
        return require('trouble.sources.snacks').actions.trouble_open.action(...)
      end,
    },
    sources = {
      explorer = { exclude = excluded },
      grep = { exclude = excluded },
      files = { exclude = excluded },
    },
    win = {
      input = {
        keys = {
          ['<a-t>'] = {
            'trouble_open',
            mode = { 'n', 'i' },
          },
        },
      },
    },
  },
}

-- [INFO] These are in an autocmd because these overwrite the set values otherwise
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    -- toggle options
    -- LazyVim.format.snacks_toggle():map("<leader>uf")
    -- LazyVim.format.snacks_toggle(true):map("<leader>uF")
    Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
    Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
    Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
    Snacks.toggle.diagnostics():map('<leader>ud')
    Snacks.toggle.line_number():map('<leader>ul')
    Snacks.toggle
      .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = 'Conceal Level' })
      :map('<leader>uc')
    Snacks.toggle.treesitter():map('<leader>uT')
    Snacks.toggle.dim():map('<leader>uD')
    Snacks.toggle.animate():map('<leader>ua')
    Snacks.toggle.indent():map('<leader>ug')
    Snacks.toggle.scroll():map('<leader>uS')
    Snacks.toggle.profiler():map('<leader>dpp')
    Snacks.toggle.profiler_highlights():map('<leader>dph')

    if vim.lsp.inlay_hint then
      Snacks.toggle.inlay_hints():map('<leader>uh')
    end

    Snacks.toggle.zoom():map('<leader>wm'):map('<leader>uZ')
    Snacks.toggle.zen():map('<leader>uz')

    -- gitsigns
    Snacks.toggle({
      name = 'Git Signs',
      get = function()
        return require('gitsigns.config').config.signcolumn
      end,
      set = function(state)
        require('gitsigns').toggle_signs(state)
      end,
    }):map('<leader>uG')
  end,
})

local map = vim.keymap.set

map('n', '<leader>bd', function()
  Snacks.bufdelete()
end, { desc = 'Delete Buffer' })
map('n', '<leader>bo', function()
  Snacks.bufdelete.other()
end, { desc = 'Delete Other Buffers' })

-- Scratch buffers
map('n', '<leader>.', function()
  Snacks.scratch()
end, { desc = 'Toggle Scratch Buffer' })
map('n', '<leader>S', function()
  Snacks.scratch.select()
end, { desc = 'Select Scratch Buffer' })
map('n', '<leader>dps', function()
  Snacks.profiler.scratch()
end, { desc = 'Profiler Scratch Buffer' })

map('n', '<leader>,', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })

map('n', '<leader>/', function()
  -- Snacks.picker.grep()
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local cwd = (git_root and vim.v.shell_error == 0) and git_root or vim.fn.getcwd()
  Snacks.picker.grep { cwd = cwd }
end, { desc = 'Grep (Root Dir)' })

map('n', '<leader>:', function()
  Snacks.picker.command_history()
end, { desc = 'Command History' })

map('n', '<leader><space>', function()
  -- Snacks.picker.smart()
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local cwd = (git_root and vim.v.shell_error == 0) and git_root or vim.fn.getcwd()
  Snacks.picker.files { cwd = cwd }
end, { desc = 'Find Files (Root Dir)' })

map('n', '<leader>n', function()
  Snacks.picker.notifications()
end, { desc = 'Notification History' })
map('n', '<leader>un', function()
  Snacks.notifier.hide()
end, { desc = 'Dismiss All Notifications' })

-- find
map('n', '<leader>fB', function()
  Snacks.picker.buffers { hidden = true, nofile = true }
end, { desc = 'Buffers (all)' })
map('n', '<leader>fc', function()
  Snacks.picker.files { cwd = vim.fn.stdpath('config') }
end, { desc = 'Find Config File' })
map('n', '<leader>ff', function()
  Snacks.picker.files()
end, { desc = 'Find Files' })
map('n', '<leader>fs', function()
  Snacks.picker.smart()
end, { desc = 'Find Files (Smart)' })
map('n', '<leader>fg', function()
  Snacks.picker.git_files()
end, { desc = 'Find Files (git-files)' })
map('n', '<leader>fr', function()
  Snacks.picker.recent()
end, { desc = 'Recent' })
map('n', '<leader>fR', function()
  Snacks.picker.recent { filter = { cwd = true } }
end, { desc = 'Recent (cwd)' })
map('n', '<leader>fp', function()
  Snacks.picker.projects()
end, { desc = 'Projects' })
-- git
map('n', '<leader>gd', function()
  Snacks.picker.git_diff()
end, { desc = 'Git Diff (hunks)' })
map('n', '<leader>gD', function()
  Snacks.picker.git_diff { base = 'origin', group = true }
end, { desc = 'Git Diff (origin)' })
map('n', '<leader>gs', function()
  Snacks.picker.git_status()
end, { desc = 'Git Status' })
map('n', '<leader>gS', function()
  Snacks.picker.git_stash()
end, { desc = 'Git Stash' })
map('n', '<leader>gi', function()
  Snacks.picker.gh_issue()
end, { desc = 'GitHub Issues (open)' })
map('n', '<leader>gI', function()
  Snacks.picker.gh_issue { state = 'all' }
end, { desc = 'GitHub Issues (all)' })
map('n', '<leader>gp', function()
  Snacks.picker.gh_pr()
end, { desc = 'GitHub Pull Requests (open)' })
map('n', '<leader>gP', function()
  Snacks.picker.gh_pr { state = 'all' }
end, { desc = 'GitHub Pull Requests (all)' })
-- Grep
map('n', '<leader>sb', function()
  Snacks.picker.lines()
end, { desc = 'Buffer Lines' })
map('n', '<leader>sB', function()
  Snacks.picker.grep_buffers()
end, { desc = 'Grep Open Buffers' })
map('n', '<leader>sg', function()
  Snacks.picker.grep()
end, { desc = 'Grep' })
map('n', '<leader>sp', function()
  Snacks.picker.lazy()
end, { desc = 'Search for Plugin Spec' })
map({ 'n', 'x' }, '<leader>sw', function()
  Snacks.picker.grep_word()
end, { desc = 'Visual selection or word' })

-- search
map('n', '<leader>s"', function()
  Snacks.picker.registers()
end, { desc = 'Registers' })
map('n', '<leader>s/', function()
  Snacks.picker.search_history()
end, { desc = 'Search History' })
map('n', '<leader>sa', function()
  Snacks.picker.autocmds()
end, { desc = 'Autocmds' })
map('n', '<leader>sc', function()
  Snacks.picker.command_history()
end, { desc = 'Command History' })
map('n', '<leader>sC', function()
  Snacks.picker.commands()
end, { desc = 'Commands' })
map('n', '<leader>sd', function()
  Snacks.picker.diagnostics()
end, { desc = 'Diagnostics' })
map('n', '<leader>sD', function()
  Snacks.picker.diagnostics_buffer()
end, { desc = 'Buffer Diagnostics' })
map('n', '<leader>sh', function()
  Snacks.picker.help()
end, { desc = 'Help Pages' })
map('n', '<leader>sH', function()
  Snacks.picker.highlights()
end, { desc = 'Highlights' })
map('n', '<leader>si', function()
  Snacks.picker.icons()
end, { desc = 'Icons' })
map('n', '<leader>sj', function()
  Snacks.picker.jumps()
end, { desc = 'Jumps' })
map('n', '<leader>sk', function()
  Snacks.picker.keymaps()
end, { desc = 'Keymaps' })
map('n', '<leader>sl', function()
  Snacks.picker.loclist()
end, { desc = 'Location List' })
map('n', '<leader>sM', function()
  Snacks.picker.man()
end, { desc = 'Man Pages' })
map('n', '<leader>sm', function()
  Snacks.picker.marks()
end, { desc = 'Marks' })
map('n', '<leader>sR', function()
  Snacks.picker.resume()
end, { desc = 'Resume' })
map('n', '<leader>sq', function()
  Snacks.picker.qflist()
end, { desc = 'Quickfix List' })
map('n', '<leader>su', function()
  Snacks.picker.undo()
end, { desc = 'Undotree' })
-- ui
map('n', '<leader>uC', function()
  Snacks.picker.colorschemes()
end, { desc = 'Colorschemes' })
map('n', '<leader>st', function()
  Snacks.picker.todo_comments()
end, { desc = 'Todo' })
map('n', '<leader>sT', function()
  Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
end, { desc = 'Todo/Fix/Fixme' })

-- lazygit
if vim.fn.executable('lazygit') == 1 then
  map('n', '<leader>gg', function()
    Snacks.lazygit()
  end, { desc = 'Lazygit (cwd)' })
end

map('n', '<leader>gL', function()
  Snacks.picker.git_log()
end, { desc = 'Git Log (cwd)' })
map('n', '<leader>gb', function()
  Snacks.picker.git_log_line()
end, { desc = 'Git Blame Line' })
map('n', '<leader>gf', function()
  Snacks.picker.git_log_file()
end, { desc = 'Git Current File History' })
-- map("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = LazyVim.root.git() }) end, { desc = "Git Log" })
map({ 'n', 'x' }, '<leader>gB', function()
  Snacks.gitbrowse()
end, { desc = 'Git Browse (open)' })
map({ 'n', 'x' }, '<leader>gY', function()
  Snacks.gitbrowse {
    open = function(url)
      vim.fn.setreg('+', url)
    end,
    notify = false,
  }
end, { desc = 'Git Browse (copy)' })

-- floating terminal
map('n', '<leader>fT', function()
  Snacks.terminal()
end, { desc = 'Terminal (cwd)' })
-- map("n", "<leader>ft", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
-- map({"n","t"}, "<c-/>",function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
-- map({"n","t"}, "<c-_>",function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "which_key_ignore" })

-- debug
map({ 'n', 'x' }, '<localleader>r', function()
  Snacks.debug.run()
end, { desc = 'Run Lua' })
-- map({"n", "x"}, "<localleader>r", function() Snacks.debug.run() end, { desc = "Run Lua", ft = "lua" })
