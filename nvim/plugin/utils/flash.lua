require('flash').setup {
  -- modes = {
  --   char = {
  --     jump_labels = true,
  --   },
  -- },
}

local map = vim.keymap.set

-- map({ 'n', 'x', 'o' }, 's', function()
--   require('flash').jump()
-- end, { desc = 'Flash' })

map({ 'n' }, 'S', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })

map({ 'c' }, '<c-s>', function()
  require('flash').toggle()
end, { desc = 'Toggle Flash Search' })

map({ 'n', 'o', 'x' }, 'gm', function()
  require('flash').jump { pattern = vim.fn.expand('<cword>') }
end, { desc = 'Word mentions (Flash)' })

-- map({ 'n', 'o', 'x' }, 'gw', function()
--   require('flash').jump { search = {
--     mode = function(str)
--       return '\\<' .. str
--     end,
--   } }
-- end, { desc = 'Go to word (Flash)' })

-- map({ 'n', 'o', 'x' }, 'gl', function()
--   require('flash').jump {
--     search = { mode = 'search', max_length = 0 },
--     label = { after = { 0, 0 } },
--     pattern = '^',
--   }
-- end, { desc = 'Go to line (Flash)' })
