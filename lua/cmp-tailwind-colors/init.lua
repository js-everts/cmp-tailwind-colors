local config = {
  width = 2,           -- width of color box. @deprecated use format to customize the text width
  enable_alpha = true, -- requires pumblend > 0
}

config.format = function(color, _, _)
  return {
    text = string.rep(" ", config.width),
    fg = color,
    bg = color,
  }
end

-- is there a better way to do this?
local function parse_color(color)
  -- tailwind gives us integers for rgb values and a float [0,1] for the alpha value
  local r, g, b, a

  -- parse rgb
  r, g, b = color:match("^rgb%((%d+), (%d+), (%d+)%)$")
  if r and g and b then
    return tonumber(r), tonumber(g), tonumber(b), 1
  end

  -- parse rgba
  r, g, b, a = color:match("^rgba%((%d+), (%d+), (%d+), (.+)%)$")
  if r and g and b and a then
    return tonumber(r), tonumber(g), tonumber(b), tonumber(a)
  end
end

local function to_hex(r, g, b)
  return string.format("#%02X%02X%02X", r, g, b)
end

M = {}

M.setup = function(options)
  if options == nil then
    return
  end

  for k, v in pairs(options) do
    config[k] = v
  end
end

M.format = function(entry, item)
  if item.kind ~= "Color" then
    return item
  end

  local entryItem = entry:get_completion_item()
  -- is this nil check necessary?
  if entryItem == nil then
    return item
  end

  local doc = entryItem.documentation
  if doc == nil or type(doc) ~= "string" then
    return item
  end

  local r, g, b, a = parse_color(doc)
  if r == nil then
    return item
  end

  local color = to_hex(r, g, b)
  local opts = config.format(color, entry, item)

  local hl_group = "cmp_tailwind_colors_" .. color:sub(2) .. a
  if vim.fn.hlexists(hl_group) == 0 then
    local hl_opts = { fg = opts.fg, bg = opts.bg }
    if a ~= nil and config.enable_alpha then
      hl_opts.blend = 100 - (a * 100)
    end
    vim.api.nvim_set_hl(0, hl_group, hl_opts)
  end

  item.kind_hl_group = hl_group
  if opts.text ~= nil then
    item.kind = opts.text
  end

  return item
end

return M
