require('nightfox').setup {
  options = {
    styles = { -- Style to be applied to different syntax groups
      comments = 'italic',
    },
    inverse = { -- Inverse highlight for different types
      match_paren = true,
      visual = true,
      search = true,
    },
  },
}

vim.cmd.colorscheme('dawnfox')
