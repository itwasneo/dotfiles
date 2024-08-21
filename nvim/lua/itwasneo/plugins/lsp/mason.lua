return {
    "williamboman/mason.nvim",               -- LSP Installer
    dependencies = {
        "williamboman/mason-lspconfig.nvim", -- Plugin between mason and lspconfig
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")

        mason.setup()
        mason_lspconfig.setup({
            ensure_installed = {
                "bashls",
                "pyright",
                "rust_analyzer",
                "lua_ls",
                "markdown_oxide",
            },
        })
    end,
}
