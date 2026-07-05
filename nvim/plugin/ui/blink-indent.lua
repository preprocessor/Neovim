local indent = require('blink.indent')
vim.keymap.set('n', '<leader>ug', function() indent.enable(not indent.is_enabled()) end, { desc = 'Toggle indent guides' })
