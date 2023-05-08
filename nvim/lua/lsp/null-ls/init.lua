local M = {}

function M.setup()
    local status_ok, null_ls = pcall(require, "null-ls")
    if not status_ok then
        return
    end

    local formatting = null_ls.builtins.formatting
    -- local diagnostics = null_ls.builtins.diagnostics
    local on_attach = require("lsp.handlers").on_attach
    local capabilities = require("lsp.handlers").capabilities

    null_ls.setup({
        debug = false,
        sources = {
            formatting.prettier,
            formatting.rustfmt.with({ extra_args = { "--edition=2021" } }),
            -- formatting.stylua,
            -- formatting.black.with({ extra_args = { "--fast" } }),
            -- diagnostics.flake8,
        },
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

return M
