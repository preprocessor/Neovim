require('github-theme').setup {
  options = {
    transparent = true,
    styles = { -- Style to be applied to different syntax groups
      comments = 'italic', -- Value is any valid attr-list value `:help attr-list`
    },
    inverse = { -- Inverse highlight for different types
      match_paren = true,
      visual = true,
      search = true,
    },
  },
}

vim.cmd.colorscheme('github_light_high_contrast')
