if vim.g.did_load_lualine_plugin then
  return
end
vim.g.did_load_lualine_plugin = true

vim.o.laststatus = 3

---Indicators for special modes,
---@return string status
local function extra_mode_status()
  -- recording macros
  local reg_recording = vim.fn.reg_recording()
  if reg_recording ~= '' then
    return ' @' .. reg_recording
  end
  -- executing macros
  local reg_executing = vim.fn.reg_executing()
  if reg_executing ~= '' then
    return ' @' .. reg_executing
  end
  -- ix mode (<C-x> in insert mode to trigger different builtin completion sources)
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'ix' then
    return '^X: (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)'
  end
  return ''
end

-- PERF: we don't need this lualine require madness 🤷
local lualine_require = require('lualine_require')
lualine_require.require = require

local Snacks = require('snacks')

require('lualine').setup {
  globalstatus = true,
  options = {
    disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'ministarter', 'snacks_dashboard' } },
    section_separators = { left = '', right = '' },
    component_separators = { left = '│', right = '│' },
  },
  sections = {
    lualine_a = { {
      'mode',
      fmt = function(str)
        return str:sub(1, 3)
      end,
    } },
    lualine_b = {},
    lualine_c = { 'filename' },

    lualine_x = {
      'filetype',
      -- stylua: ignore
      {
        function() return require("noice").api.status.command.get() end,
        cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
        color = function() return { fg = Snacks.util.color("Statement") } end,
      },
      -- stylua: ignore
      {
        function() return require("noice").api.status.mode.get() end,
        cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
        color = function() return { fg = Snacks.util.color("Constant") } end,
      },
    },
    lualine_y = {
      { extra_mode_status },
    },
    lualine_z = {
      { 'progress', padding = { left = 1, right = 1 } },
      { 'location', padding = { left = 0, right = 1 } },
    },
  },
  extensions = { 'fzf' },
}
