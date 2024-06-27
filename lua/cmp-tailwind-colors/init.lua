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
local function parse_color_as_rgb(color)
  -- tailwind gives us integers for rgb values and a float [0,1] for the alpha value
  local r, g, b, a

  -- parse rgb
  r, g, b = color:match("^rgb%((%d+), (%d+), (%d+)%)$")
  if r and g and b then
    return string.format("#%02X%02X%02X", tonumber(r), tonumber(g), tonumber(b)), 100
  end

  -- parse rgba
  r, g, b, a = color:match("^rgba%((%d+), (%d+), (%d+), (.+)%)$")
  if r and g and b and a then
    return string.format("#%02X%02X%02X", tonumber(r), tonumber(g), tonumber(b)), tonumber(a) * 100
  end
end

local function parse_color_as_hex(color)
  local hex = color:match("^#%x%x%x%x%x%x%x?%x?$")
  local alpha = 100

  if hex ~= nil and hex:len() > 7 then
    alpha = tonumber(hex:sub(8, 10), 16) / 255 * 100
    hex = hex:sub(0, 7)
  end

  return hex, alpha
end

local function parse_color(color)
  local hex, alpha = parse_color_as_hex(color)
  if hex == nil then
    hex, alpha = parse_color_as_rgb(color)
  end

  return hex, alpha
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

  local hex, alpha = parse_color(doc)
  if hex == nil then
    return item
  end

  local opts = config.format(hex, entry, item)

  local hl_group = "cmp_tailwind_colors_" .. hex:sub(2) .. alpha
  if vim.fn.hlexists(hl_group) == 0 then
    local hl_opts = { fg = opts.fg, bg = opts.bg }
    if config.enable_alpha then
      hl_opts.blend = vim.fn.float2nr(vim.fn.round(100 - alpha))
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
