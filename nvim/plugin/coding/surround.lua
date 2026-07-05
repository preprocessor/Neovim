require("nvim-surround").setup()

vim.g.nvim_surround_no_mappings = true

vim.keymap.set("x", "S", "<Plug>(nvim-surround-visual)", { desc = "Add a surrounding pair around a visual selection" })
vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)", { desc = "Delete a surrounding pair" })
vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)", { desc = "Change a surrounding pair" })
