local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Titles
map({ 'n', 'v' }, '<Leader>Cb', '<Cmd>CBccbox<CR>', opts)
-- Named parts
map({ 'n', 'v' }, '<Leader>Ct', '<Cmd>CBllline<CR>', opts)
-- Simple line
map('n', '<Leader>Cl', '<Cmd>CBline<CR>', opts)
-- keymap("i", "<M-l>", "<Cmd>CBline<CR>", opts) -- To use in Insert Mode
-- Marked comments
map({ 'n', 'v' }, '<Leader>Cm', '<Cmd>CBllbox14<CR>', opts)
-- Removing a box is simple enough with the command (CBd), but if you
-- use it a lot:
-- keymap({ "n", "v" }, "<Leader>cd", "<Cmd>CBd<CR>", opts)
