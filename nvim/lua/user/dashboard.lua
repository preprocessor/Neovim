local width = 83
local border_hl = 'MsgArea'
local plain_text_hl = 'MsgArea'

local filler = { text = { '│' .. string.rep(' ', width - 2) .. '│' }, hl = border_hl }

local header = [[
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                      ▄▀                                         │
│                          ░   ░ ░░  ▄▓█▌ ░░ ░   ░                                │
│ ▄▄    ▀▀▓▓█▄▄▄   ▄▄███▄          ▄▓████▄                   ▄▄   🬋▀▀▓▓▄▄▄        │
│  ▀▓▓▓▄▄  ▀▓███▓▓▄ ▀██▓▓█▄▄▄    ▄▓▓▓▓█████▄▄     ▄🬋█▓▄▄      ▀▓▓▓▄▄   ▀███▓▓▄    │
│   ▐▓████▓▄  ▀███▓▓▄ ██▓▌  ▀▓██▄ ▀▀▀████▓▀▀███▄▄▄   ▀████▄▄   ▐▓████▓▓▄ ▀███▓▓▄  │
│    ████▓▓▌   ▐███▓▓▌ ▀▀▀🬋  ▐█████▓▄ ▀ ▄▄▄████▓▀ ▄▀   █▓███▓▄  ████▓▓▌   ▐███▓▓▌ │
│    ▐████▓   ▄████▓▀ ▄▓▓▄    ███▓█▌ ▄██████▓▀▀ ▄▓▌    ▐▓████▓▓▄ ▀███▓   ▄████▓▀  │
│     ████▓ ▀▀▀▀▀▀ ▄▄███▀██▄▄ ▐█▓▓▓ ████▓▀▀  ▄██▓▓▌     █▀▓▀██▓▓▌ ███▓🬋▀██▀▀▀     │
│     ███▓▓▌🬋▀▓██▄▄ ▀██▄▓▄██▀▀🬋██▓▌  ▀██▄█▓▄▄ ▀▀█▓▓     ▐█▄███▓▓▌ ██▓▓  ▐███▄▄    │
│    ▐██▓▓▓▓  ▐███▓▓▄ ▀███▀    ██▓▓    ▀█████▓▓▄▄▄      ▐█████▓▓ ▐█▓▓▓   ▓███▓▓▄  │
│   ▄█████▓▓▓▄ ████▓▓▌ ██▓▌   ▐███▓▓     ▀██████▓▓▓▓▀  ▄█████▓▀ ▄████▓▌  ▐████▓▓▌ │
│ 🬋▀▀▀   ▀▀▓▀ ▐█████▓▓ ▐▓▓▓▓▄▄▓████▓▓      ▀███▓▓▀  🬋▄▓██▓▓▀▀ 🬭█▀   ▀▀▀  ▀▀▀███▓▓ │
│           ▄▓▓▓███▓▓▓▌ ▀▓▓▀▀     ▀█▓▓       ▓▓▀      ▀▀▀   ▗▖🬂               ▀▀▓ │
│                 ▀▀▀▓▓▄            ▀▓▓▄      ▀▄           ▄  R A Z O R           │
│                      ▀▓             ▀▓▌        ▀ ■ ▄ ■ ▀     1 9 1 1            │
│                       ▀▄             ▐▌                                         │]]
local footer = [[
│                                                                                 │
└──────── ───── ── ── ─ ── ──    ─             ─     ─ ─ ── ─── ──── ─── ─────────┘
 ▀████████████████████████████████████████████████▄███████████████████▄██████████▀
  ▐▀██▀     ▀▀■▄ ▀▀▀▀▀▀▀▄▀▀▀▀▀▀▀▀■▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▄▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀████
   ▐█▀▄        ▀▄                                                ▄▀▀▀▀▄▄    ████▌
   █   ▀▀▄▄▄■   ▀■▄▄  •-----•  ─  𝐍  Σ  Ø  𝐕  i 𝓶   ─  •-----• ■▀       ▀▄▄████▀
  ▀                                                                         ▀▄]]

return {
  preset = {
    -- stylua: ignore
    ---@type snacks.dashboard.Item[]
    keys = {
      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      filler,
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      filler,
      { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      filler,
      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      filler,
      { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
      filler,
      { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd ='~/Configuration/Neovim/'})" },
      filler,
      { icon = " ", key = "s", desc = "Restore Session", action = ":lua require('persistence').load({ last = true })" },
      filler,
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
  },

  formats = {
    key = function(item)
      -- return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
      -- return { { item.key, hl = "key" }, { " │", hl = "Title" } }
      return {
        { '[', hl = plain_text_hl },
        { item.key, hl = '@string.special.url' },
        { ']', hl = plain_text_hl },
        { '  │', hl = border_hl },
      }
    end,
    icon = function(item)
      return { { '│   ', hl = border_hl }, { item.icon, width = 2, hl = plain_text_hl } }
    end,
    desc = function(item)
      -- return { { item.desc, hl = "@constant.builtin" } }
      return { { item.desc, hl = 'MsgArea' } }
    end,
  },

  width = width,

  sections = {
    { text = { header, hl = border_hl } },
    { section = 'keys' },
    { text = { footer, hl = border_hl } },
  },
}
