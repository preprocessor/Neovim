require('gruvbox').setup {
  -- terminal_colors = true, -- add neovim terminal colors
  -- undercurl = false,
  -- underline = true,
  -- bold = true,
  italic = {
    strings = false,
    emphasis = false,
    comments = true,
    operators = false,
    folds = false,
  },
  -- strikethrough = true,
  -- invert_selection = false,
  -- invert_signs = false,
  -- invert_tabline = false,
  -- inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = 'soft', -- can be "hard", "soft" or empty string
  -- palette_overrides = {},
  overrides = {
    HopNextKey = { fg = '#f2e5bc', bg = '#7a7915' },
    HopNextKey1 = { fg = '#f2e5bc', bg = '#5b5b10' },
    HopNextKey2 = { fg = '#f2e5bc', bg = '#37370a' },
    HopUnmatched = { fg = '#d5c4a1', italic = true },
    HopCursor = { fg = '#f2e5bc', bg = '#d79921' },
    HopPreview = { fg = '#d79921' },
  },
  -- transparent_mode = true,
}

-- vim.cmd.colorscheme('gruvbox')
