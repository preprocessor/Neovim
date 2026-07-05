require('render-markdown').setup {
  completions = { lsp = { enabled = true } },
  render_modes = true,

  anti_conceal = {
    disabled_modes = { 'n', 'c', 't' },
  },

  code = {
    sign = false,
    border = 'thin',
    position = 'left',
    width = 'block',
    above = '▁',
    below = '▔',
    language_left = '█',
    language_right = '█',
    language_border = '▁',
    left_pad = 1,
    right_pad = 1,
  },

  heading = {
    border = true,
    -- border_virtual = true,
    -- position = 'left',
    position = 'right',
    width = 'block',
    left_pad = 1,
    right_pad = 1,
    icons = {
      '',
      '',
      '',
      '',
      '',
      '',
    },
  },

  indent = {
    enabled = true,
    skip_level = 0,
    skip_heading = true,
  },

  latex = { bottom_pad = 1 },

  quote = { repeat_linebreak = true },

  win_options = {
    showbreak = {
      default = '',
      rendered = '  ',
    },
    breakindent = {
      default = true,
      rendered = true,
    },
    breakindentopt = {
      default = '',
      rendered = '',
    },
  },
}
