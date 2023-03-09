# cmp-tailwind-colors

| Some results | With transparency (requires `pumblend > 0`) |
|-|-|
| ![Screenshot](https://user-images.githubusercontent.com/7759571/224038448-275261a9-c707-44ca-84ad-1de8dfecce0a.png) | ![Screenshot with transparency](https://user-images.githubusercontent.com/7759571/224045809-d02accff-235d-4857-816a-d3f8db0d89b9.png) |

Adds TailwindCSS color hints to `nvim-cmp` completion results.

# Requirements

- `nvim-cmp`
- `tailwindcss-language-server`

# Configuration

Setup `cmp-tailwind-colors`. This is optional. Use it to change the default appearance.

```lua
require("cmp-tailwind-colors").setup({
  width = 2, -- width of color box
  enable_alpha = true, -- requires pumblend > 0.
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
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

cmp.setup({
  formatting = {
    fields = { "kind", "abbr", "menu" } -- order of columns,
    format = function(entry, item)
      if item.kind == "Color" then
        item = require("cmp-tailwind-colors").format(entry, item)

        if item.kind ~= "Color" then
          item.menu = "Color"
          return item
        end
      end

      item.menu = item.kind
      item.kind = kind_icons[item.kind] .. " "
      return item
    end,
  },
})

```
