require('zellij-nav').setup()

local map = vim.keymap.set

map('n', '<c-h>', '<cmd>ZellijNavigateLeft<cr>')
map('n', '<c-j>', '<cmd>ZellijNavigateDown<cr>')
map('n', '<c-k>', '<cmd>ZellijNavigateUp<cr>')
map('n', '<c-l>', '<cmd>ZellijNavigateRight<cr>')
