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

local trouble = require('trouble')
local symbols = trouble.statusline {
  mode = 'symbols',
  groups = {},
  title = false,
  filter = { range = true },
  format = '{kind_icon}{symbol.name:Normal}',
  hl_group = 'lualine_c_normal',
}

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
    lualine_b = { 'branch' },
    lualine_c = {
      {
        'diff',
        symbols = {
          added = ' ',
          modified = ' ',
          removed = ' ',
        },
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
      },

      'filename',
      {
        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      },
    },

    lualine_x = {
      'encoding',
      'fileformat',
      'filetype',
      Snacks.profiler.status(),
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
      -- stylua: ignore
      {
        function() return "  " .. require("dap").status() end,
        cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
        color = function() return { fg = Snacks.util.color("Debug") } end,
      },
    },
    lualine_y = {
      { 'progress', padding = { left = 1, right = 1 } },
      { 'location', padding = { left = 0, right = 1 } },
    },
    lualine_z = {
      { extra_mode_status },
    },
  },
  extensions = { 'fzf' },
}
