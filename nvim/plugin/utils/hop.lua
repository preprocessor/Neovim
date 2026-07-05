local hop = require('hop')

hop.setup {
  keys = 'etovxqpdygfblzhckisuran',
  create_hl_autocmd = false,
}

local map = vim.keymap.set

map({ 'n', 'x', 'o' }, 's', function()
  vim.cmd('HopWordMW')
end, { desc = 'Hop' })

map({ 'n', 'x', 'o' }, 't', function()
  hop.hint_words {
    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
    multi_windows = true,
  }
end, { remap = true, desc = 'Hop to word (After cursor)' })

map({ 'n', 'x', 'o' }, 'T', function()
  hop.hint_words {
    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
    multi_windows = true,
  }
end, { remap = true, desc = 'Hop to word (Before cursor)' })

map({ 'n', 'o', 'x' }, 'gl', function()
  hop.hint_lines_skip_whitespace {
    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
    multi_windows = true,
  }
end, { desc = 'Hop to line (After cursor)' })

map({ 'n', 'o', 'x' }, 'gL', function()
  hop.hint_lines_skip_whitespace {
    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
    multi_windows = true,
  }
end, { desc = 'Hop to line (Before cursor)' })
