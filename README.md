# cmp-tailwind-colors

| Some results | With transparency (requires `pumblend > 0`) |
|-|-|
| ![Screenshot](https://user-images.githubusercontent.com/7759571/224038448-275261a9-c707-44ca-84ad-1de8dfecce0a.png) | ![Screenshot with transparency](https://user-images.githubusercontent.com/7759571/224045809-d02accff-235d-4857-816a-d3f8db0d89b9.png) |

Adds TailwindCSS color hints to `nvim-cmp` completion results.

# Requirements

- `nvim-cmp`
- `tailwindcss-language-server`

# Configuration

Setup `cmp-tailwind-colors`. This is optional. Use it to change the appearance.
These are the defaults.

```lua
require("cmp-tailwind-colors").setup({
  enable_alpha = true, -- requires pumblend > 0.

  format = function(itemColor) then
    return {
      fg = itemColor,
      bg = itemColor, -- or nil if you dont want a background color
      text = "  " -- or use an icon
    }
  end
})
```

Integrate with `nvim-cmp`. This is the simplest way to get up and running.

```lua
cmp.setup({
  formatting = {
    format = require("cmp-tailwind-colors").format
  }
}

```

To replicate the setup shown in the screenshot above use the config below

```lua
local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}

cmp.setup({
  formatting = {
    fields = { "kind", "abbr", "menu" } -- order of columns,
    format = function(entry, item)
        item.menu = item.kind
        item = require("cmp-tailwind-colors").format(entry, item)
        if kind_icons[item.kind] then
          item.kind = kind_icons[item.kind] .. " "
        end
      return item
    end,
  },
})

```
