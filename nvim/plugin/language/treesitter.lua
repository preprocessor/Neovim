if vim.g.did_load_treesitter_plugin then
  return
end
vim.g.did_load_treesitter_plugin = true

local map = vim.keymap.set

require('nvim-treesitter').setup {
  indent = { enable = true },
  highlight = { enable = true },
  folds = { enable = true },
}

map({ 'n', 'x', 'o' }, 's', function()
  require('flash').jump()
end, { desc = 'Flash' })

map({ 'n', 'o', 'x' }, 'S', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })

map('o', 'r', function()
  require('flash').remote()
end, { desc = 'Remote Flash' })

map({ 'o', 'x' }, 'R', function()
  require('flash').treesitter_search()
end, { desc = 'Treesitter Search' })

map({ 'c' }, '<c-s>', function()
  require('flash').toggle()
end, { desc = 'Toggle Flash Search' })

-- Simulate nvim-treesitter incremental selection
map({ 'n', 'o', 'x' }, '<c-space>', function()
  require('flash').treesitter { actions = { ['<c-space>'] = 'next', ['<BS>'] = 'prev' } }
end, { desc = 'Treesitter Incremental Selection' }) -- nvim-treesitter-textobjects select

map({ 'x', 'o' }, 'af', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
end, {})
map({ 'x', 'o' }, 'if', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
end, {})
map({ 'x', 'o' }, 'ac', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
end, {})
map({ 'x', 'o' }, 'ic', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
end, {})
map({ 'x', 'o' }, 'as', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
end, {})

-- swap
map('n', '<leader>a', function()
  require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
end, {})
map('n', '<leader>A', function()
  require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.outer')
end, {})

-- move
map({ 'n', 'x', 'o' }, ']m', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
end, { desc = '[m] next function (start)' })
map({ 'n', 'x', 'o' }, ']M', function()
  require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
end, { desc = '[M] next function (end)' })
map({ 'n', 'x', 'o' }, ']p', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.outer', 'textobjects')
end, { desc = '[p] next parameter (start)' })
map({ 'n', 'x', 'o' }, ']P', function()
  require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.outer', 'textobjects')
end, { desc = '[P] next parameter (end)' })
map({ 'n', 'x', 'o' }, '[m', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
end, { desc = '[m] previous function (start)' })
map({ 'n', 'x', 'o' }, '[M', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
end, { desc = '[M] previous function (end)' })
map({ 'n', 'x', 'o' }, '[p', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.outer', 'textobjects')
end, { desc = 'previous [p]arameter (start)' })
map({ 'n', 'x', 'o' }, '[P', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.outer', 'textobjects')
end, { desc = 'previous [P]arameter (end)' })

require('treesitter-context').setup {
  max_lines = 3,
}

require('ts_context_commentstring').setup()

-- Tree-sitter based folding
-- vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
