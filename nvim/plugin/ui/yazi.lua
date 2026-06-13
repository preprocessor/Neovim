require('yazi').setup {
  open_for_directories = true,
  floating_window_scaling_factor = 0.8,
  -- yazi_floating_window_winblend = 10,
  yazi_floating_window_border = "single"
}

vim.keymap.set('n', '<leader>e', function()
  require('yazi').yazi()
end, { desc = 'File Explorer (Yazi)' })

-- 👇 if you use `open_for_directories=true`, this is recommended.
--
-- mark netrw as loaded so it's not loaded at all.
-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
vim.g.loaded_netrwPlugin = 1
