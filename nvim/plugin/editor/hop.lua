local hop = require('hop')

hop.setup {
  create_hl_autocmd = false,
}

vim.keymap.set('n', '<leader>hw', '<cmd>HopWord<CR>', { desc = 'Hop to Word' })
vim.keymap.set('n', '<leader>hl', '<cmd>HopLine<CR>', { desc = 'Hop to Line' })
vim.keymap.set('n', '<leader>hc', '<cmd>HopChar1<CR>', { desc = 'Hop to Character' })
