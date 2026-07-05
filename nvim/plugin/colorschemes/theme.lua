require('catppuccin').setup {
  flavour = 'mocha', -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = 'latte',
    dark = 'mocha',
  },
  transparent_background = true, -- disables setting the background color.
  float = {
    transparent = false, -- enable transparent floating windows
    solid = false, -- use solid styling for floating windows, see |winborder|
  },
  term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false, -- dims the background color of inactive window
    shade = 'dark',
    percentage = 0.15, -- percentage of the shade to apply to the inactive window
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  no_underline = false, -- Force no underline
  styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { 'italic' }, -- Change the style of comments
    conditionals = { 'italic' },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    -- miscs = {}, -- Uncomment to turn off hard-coded styles
  },
  lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
    virtual_text = {
      errors = { 'italic' },
      hints = { 'italic' },
      warnings = { 'italic' },
      information = { 'italic' },
      ok = { 'italic' },
    },
    underlines = {
      errors = { 'underline' },
      hints = { 'underline' },
      warnings = { 'underline' },
      information = { 'underline' },
      ok = { 'underline' },
    },
    inlay_hints = {
      background = true,
    },
  },
  color_overrides = {
    mocha = {
      -- rosewater = "#a06090",
      -- flamingo = "#d09090",

      -- pink = "#9f5879",     -- magenta
      -- mauve = "#d792a5",    -- light magenta
      --
      -- red = "#b8201a",      -- red
      -- maroon = "#fb5b48",   -- bright red
      --
      -- peach = "#c28a1e",    -- yellow
      -- yellow = "#fbc444",   -- bright yellow
      --
      -- green = "#898817",    -- green
      -- teal = "#bfc23c",     -- light green
      --
      -- sky = "#5e8d5f",      -- cyan
      -- sapphire = "#99c689", -- light cyan
      --
      -- blue = "#3e787a",     -- blue
      -- lavender = "#8faea2", -- light blue

      rosewater = '#EC7420',
      flamingo = '#EC7420',

      pink = '#b76285',
      mauve = '#9f5879',

      red = '#db3b28',
      maroon = '#b2332e',

      peach = '#caa030',
      yellow = '#d68a1e',

      green = '#9fa21c',
      teal = '#898817',

      sky = '#79a669',
      sapphire = '#5e8d5f',

      blue = '#4f9e92',
      lavender = '#3e787a',

      text = '#EC7420',
      subtext1 = '#EE8236',
      subtext0 = '#F08E4A',
      overlay2 = '#DBDBDB',
      overlay1 = '#D0D0D0',
      overlay0 = '#C4C4C4',
      surface2 = '#606060',
      surface1 = '#2B2B2B',
      surface0 = '#181818',
      base = '#111111',
      mantle = '#0A0A0A',
      crust = '#000000',
    },
  },
  highlight_overrides = {
    mocha = function(mocha)
      return {
        Comment = { fg = mocha.surface2, style = { 'italic' } },

        SignColumn = { bg = mocha.base },
        CursorLineNr = { bg = mocha.base },
        LineNr = { bg = mocha.mantle },
        RenderMarkdownH1Bg = { bg = '#1e2e2f', fg = '#3e787b' },
        RenderMarkdownH1 = { fg = '#3e787b' },
      }
    end,
  },
  default_integrations = true,
  auto_integrations = true,
  integrations = {
    blink_cmp = {
      style = 'bordered',
    },
    blink_indent = true,
    blink_pairs = true,
    gitsigns = true,
    grug_far = true,
    lualine = {
      mocha = function(mocha)
        return {
          normal = {
            a = { bg = mocha.blue, fg = mocha.mantle, gui = 'bold' },
            b = { bg = mocha.surface0, fg = mocha.blue },
            c = { bg = 'NONE', fg = mocha.text },
          },

          insert = {
            a = { bg = mocha.green, fg = mocha.base, gui = 'bold' },
            b = { bg = mocha.surface0, fg = mocha.green },
          },

          terminal = {
            a = { bg = mocha.green, fg = mocha.base, gui = 'bold' },
            b = { bg = mocha.surface0, fg = mocha.green },
          },

          command = {
            a = { bg = mocha.peach, fg = mocha.base, gui = 'bold' },
            b = { bg = mocha.surface0, fg = mocha.peach },
          },
          visual = {
            a = { bg = mocha.mauve, fg = mocha.base, gui = 'bold' },
            b = { bg = mocha.surface0, fg = mocha.mauve },
          },
          replace = {
            a = { bg = mocha.red, fg = mocha.base, gui = 'bold' },
            b = { bg = mocha.surface0, fg = mocha.red },
          },
          inactive = {
            a = { bg = 'NONE', fg = mocha.blue },
            b = { bg = 'NONE', fg = mocha.surface1, gui = 'bold' },
            c = { bg = 'NONE', fg = mocha.overlay0 },
          },
        }
      end,
    },
    notify = true,
    hop = true,
    mini = {
      enabled = true,
    },
    noice = true,
    snacks = {
      enabled = true,
    },
    render_markdown = true,
    lsp_trouble = true,
    which_key = true,
  },
}

require('blink.pairs').setup {
  highlights = {
    groups = {
      'BlinkPairsRed',
      'BlinkPairsYellow',
      'BlinkPairsBlue',
      'BlinkPairsOrange',
      'BlinkPairsGreen',
      'BlinkPairsPurple',
      'BlinkPairsCyan',
    },
  },
}

-- setup must be called before loading
vim.cmd.colorscheme('catppuccin-nvim')
