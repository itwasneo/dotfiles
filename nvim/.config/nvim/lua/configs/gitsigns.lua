local M = {}

function M.opts(_, opts)
  opts.preview_config = {
    border = "rounded",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  }

  return opts
end

return M
