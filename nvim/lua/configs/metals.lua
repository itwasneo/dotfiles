local M = {}

function M.setup()
  local metals_config = require("metals").bare_config()

  metals_config.settings = {
    javaHome = os.getenv "HOME" .. "/.sdkman/candidates/java/current",
    showImplicitArguments = true,
    showInferredType = true,
  }

  metals_config.on_attach = function(client, bufnr)
    require("nvchad.configs.lspconfig").on_attach(client, bufnr)
  end

  local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = nvim_metals_group,
    pattern = { "scala", "sbt" },
    callback = function()
      require("metals").initialize_or_attach(metals_config)
    end,
  })
end

return M
