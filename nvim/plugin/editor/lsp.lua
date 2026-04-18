local map = vim.keymap.set

map('n', '<leader>cl', function()
  Snacks.picker.lsp_config()
end, { desc = 'Lsp Info' })
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Goto Definition' })
map('n', 'gr', vim.lsp.buf.references, { desc = 'References', nowait = true })
map('n', 'gI', vim.lsp.buf.implementation, { desc = 'Goto Implementation' })
map('n', 'gy', vim.lsp.buf.type_definition, { desc = 'Goto T[y]pe Definition' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })

map('n', 'K', function()
  return vim.lsp.buf.hover()
end, { desc = 'Hover' })

map('n', 'gK', function()
  return vim.lsp.buf.signature_help()
end, { desc = 'Signature Help' })

map('i', '<c-k>', function()
  return vim.lsp.buf.signature_help()
end, { desc = 'Signature Help' })

map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
map({ 'n', 'x' }, '<leader>cc', vim.lsp.codelens.run, { desc = 'Run Codelens' })
map('n', '<leader>cC', vim.lsp.codelens.refresh, { desc = 'Refresh & Display Codelens' })
map('n', '<leader>cR', function()
  Snacks.rename.rename_file()
end, { desc = 'Rename File' })
map('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename' })

map('n', ']]', function()
  Snacks.words.jump(vim.v.count1)
end, { desc = 'Next Reference' })

map('n', '[[', function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = 'Prev Reference' })

map('n', '<a-n>', function()
  Snacks.words.jump(vim.v.count1, true)
end, { desc = 'Next Reference' })

map('n', '<a-p>', function()
  Snacks.words.jump(-vim.v.count1, true)
end, { desc = 'Prev Reference' })
