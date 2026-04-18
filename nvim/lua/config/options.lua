local opt = vim.opt

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- See :h <option> to see what the options do

-- Search down into subfolders
opt.path = vim.o.path .. '**'

opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.cursorline = true -- Enable highlighting of the current line
opt.showmatch = true -- Highlight matching parentheses, etc
opt.incsearch = true
opt.hlsearch = true

opt.spell = false
opt.spelllang = 'en'

opt.expandtab = true
opt.fillchars = [[foldopen:,foldclose:,diff:╱,fold: ,foldsep: ,eob: ]]
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2 -- Size of an indent
opt.shiftround = true -- Round indent

opt.foldenable = true
opt.foldlevel = 99
opt.foldmethod = 'indent'
opt.foldtext = ''

opt.history = 2000
opt.nrformats = 'bin,hex' -- 'octal'
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.cmdheight = 0

opt.clipboard = vim.env.SSH_CONNECTION and '' or 'unnamedplus' -- Sync with system clipboard
opt.completeopt = 'menu,menuone,noselect'
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer

opt.autowrite = true
opt.formatoptions = 'jcroqlnt' -- tcqj

opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'

opt.ignorecase = true -- Ignore case
opt.inccommand = 'nosplit' -- preview incremental substitute
opt.jumpoptions = 'view'
opt.laststatus = 3 -- global statusline
opt.list = true -- Show some invisible characters (tabs...

opt.pumheight = 10 -- Maximum number of entries in a popup

opt.ruler = false -- Disable the default ruler
opt.scrolloff = 10
opt.sessionoptions = 'buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds'

opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time

opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically

opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = 'longest:full,full' -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.mousemodel = 'extend'
opt.virtualedit = 'block'
opt.wrap = false
opt.linebreak = true
opt.breakindent = true
opt.breakindentopt = 'sbr,shift:5'
opt.mousescroll = 'ver:1,hor:0'
opt.showbreak = ' 󱞵 '

opt.smoothscroll = true

vim.filetype.add {
  extension = { rasi = 'rasi' },
  pattern = {
    ['.*/hypr/.*%.conf'] = 'hyprlang',
  },
}

vim.cmd([[
  set cpoptions+=n
  set t_ti=^[[1049h
  set t_te=^[[1049l^[[0\ q
]])

-- Configure Neovim diagnostic messages

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '⚠',
      [vim.diagnostic.severity.INFO] = 'ⓘ',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'single',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}
