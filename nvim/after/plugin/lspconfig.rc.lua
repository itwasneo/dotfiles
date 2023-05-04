local lsp_config_status, lspconfig = pcall(require, "lspconfig")
if not lsp_config_status then
    return
end

local on_attach = require("lsp.handlers").on_attach
local capabilities = require("lsp.handlers").capabilities

-- Lua ========================================================================
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most Likely LuaJIT in the case of NeoVim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the 'vim' global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containinga randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})
-- ============================================================================

-- Rust =======================================================================
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
        },
    },
})
-- ============================================================================

-- CSS ========================================================================
lspconfig.cssls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
-- ============================================================================

-- Typescript/Javascript ======================================================
lspconfig.tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
