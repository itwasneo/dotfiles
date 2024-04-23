return {
    "nvim-treesitter/nvim-treesitter", -- Syntax Highlighting
    event = { "BufReadPre", "BufNewFile" },
    build = ":TsUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects"
    },
    config = function()
        local treesitter = require("nvim-treesitter.configs")

        -- This setting is because of my 'runer' project ----------------------
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
            pattern = { "*.runer" },
            command = "setfiletype yaml"
        })
        -- ====================================================================

        treesitter.setup({
            auto_install = false,
            autotag = {
                enable = true
            },
            ensure_installed = {
                'rust',
                'java',
                'lua',
                'json',
                'css',
                'html',
                'toml',
                'yaml',
                'regex',
                'bash',
                'markdown',
                'markdown_inline'
            },
            highlight = {
                enable = true,
                disable = { 'html' },
            },
            indent = {
                enable = true,
                disable = { "yaml" }
            },
            ignore_install = {},
            modules = {},
            sync_install = false,
        })
    end,
}
