if vim.g.did_load_plugins_plugin then
  return
end
vim.g.did_load_plugins_plugin = true

-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs

require('nvim-surround').setup()
require('ts-comments').setup()
require('nvim-highlight-colors').setup {}
require('mini.icons').setup {
  file = {
    ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
    ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
  },
  filetype = {
    dotenv = { glyph = '', hl = 'MiniIconsYellow' },
  },
}
