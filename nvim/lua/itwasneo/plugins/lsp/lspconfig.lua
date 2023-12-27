return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local signs = {
            { name = "DiagnosticSignError", text = " " },
            { name = "DiagnosticSignWarn", text = " " },
            { name = "DiagnosticSignHint", text = " " },
            { name = "DiagnosticSignInfo", text = " " },
        }

        for _, sign in ipairs(signs) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end

        local config = {
            virtual_text = false,       -- disable virtual text
            signs = { active = signs }, -- show signs
            update_in_insert = true,
            underline = true,
            severity_sort = true,
            float = {
                focusable = false,
                border = "rounded",
                minimal = true,
                source = true,
                header = "",
                prefix = "",
            },
        }

        vim.diagnostic.config(config)

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded",
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "rounded",
        })

        local function lsp_keymaps(bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            local keymap = vim.keymap

            keymap.set("n", "gD", vim.lsp.buf.declaration, opts)                   -- Go to Declaration
            keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)       -- Show references
            keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)  -- Show implementations
            keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)      -- Show definitions
            keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- Show type definitions
            keymap.set("n", "K", vim.lsp.buf.hover, opts)                          -- Show documentation for what is under cursor
            keymap.set("n", "<C-k>", vim.diagnostic.goto_prev, opts)               -- Jump to previous diagnostic in buffer
            keymap.set("n", "<C-j>", vim.diagnostic.goto_next, opts)               -- Jump to next diagnostic in buffer
            keymap.set("n", "<C-l>",
                '<cmd> lua vim.diagnostic.open_float({focusable = false, border="rounded", source = false, header = "", prefix = "  ",})<CR>',
                opts) -- Show diagnostics for line
        end

        local function lsp_format_document(client)
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_exec(
                    [[
                    augroup Format
                        autocmd! * <buffer>
                        autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
                    augroup END
                    ]],
                    false
                )
            end
        end

        local function lsp_highlight_document(client, bufnr)
            -- Set autocommands conditional on server_capabilities
            if client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
                vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
                vim.api.nvim_create_autocmd("CursorHold", {
                    callback = vim.lsp.buf.document_highlight,
                    buffer = bufnr,
                    group = "lsp_document_highlight",
                    desc = "Document Highlight",
                })
                vim.api.nvim_create_autocmd("CursorMoved", {
                    callback = vim.lsp.buf.clear_references,
                    buffer = bufnr,
                    group = "lsp_document_highlight",
                    desc = "Clear All the References",
                })
            end
        end

        local on_attach = function(client, bufnr)
            lsp_keymaps(bufnr)
            lsp_highlight_document(client, bufnr)
            lsp_format_document(client)
        end

        local capabilities = cmp_nvim_lsp.default_capabilities()
        -- Lua ================================================================
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
        -- ====================================================================

        -- Rust ===============================================================
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
                        features = "all",
                    },
                    procMacro = {
                        enable = true,
                    },
                },
            },
        })
        -- ====================================================================

        -- CSS ================================================================
        lspconfig.cssls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
        -- ====================================================================

        -- Typescript/Javascript ==============================================
        lspconfig.tsserver.setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
        -- ====================================================================

        -- HTML ===============================================================
        lspconfig.html.setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })

        -- Ada ================================================================
        lspconfig.als.setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
        -- ====================================================================

        -- Java ===============================================================
        lspconfig.jdtls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            cmd = { 'jdtls' },
        })
        -- ====================================================================

        -- Docker =============================================================
        lspconfig.dockerls.setup {}
        -- ====================================================================

        -- Markdown ===========================================================
        lspconfig.marksman.setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }

        -- Bash ===============================================================
        lspconfig.bashls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }
        -- ====================================================================
    end
}
