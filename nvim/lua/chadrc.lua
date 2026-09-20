---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "solarized_osaka",
  -- transparency = true,
}

M.ui = {
  hl_override = {
    RenderMarkdownCode = { bg = "NONE" },
    RenderMarkdownBullet = { bg = "NONE" },
  },
}

return M
