local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang-format" },
    cpp = { "clang-format" },
  },

  formatters = {
    ["clang-format"] = {
      prepend_args = { "--style=file" },
    },
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = function(bufnr)
      local ft = vim.bo[bufnr].filetype
      return ft ~= "c" and ft ~= "cpp"
    end,
  },
}

return options
