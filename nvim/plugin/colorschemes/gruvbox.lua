-- Default options:
require('gruvbox').setup {
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = false,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  inverse = true,    -- invert background for search, diffs, statuslines and errors
  contrast = 'hard', -- can be "hard", "soft" or empty string
  dim_inactive = false,
  transparent_mode = true,

  overrides = {
    SignColumn = { bg = '#3c3836' },
    LineNr = { bg = '#282828' },
  },
}

-- values shown are defaults and will be used if not provided
require('gruvbox-material').setup {
  italics = true,    -- enable italics in general
  contrast = 'hard', -- set contrast, can be any of "hard", "medium", "soft"
}

require('lualine').setup {
  options = { theme = "gruvbox-material" },
}

vim.cmd.colorscheme('gruvbox')
