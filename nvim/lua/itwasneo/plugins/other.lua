return {
    { -- Pair brackets
        "windwp/nvim-autopairs",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            disable_filetype = { "TelescopePrompt", "vim" },
        },
    },
    { -- Pair html tags
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            filetypes = { "html", "xml" },
        },
    },
    { -- For previewing colors in files (css)
        "norcalli/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            css = { css = true },
            lua = { RRGGBB = true },
        },
    },
    { -- Comment plugin
        "numToStr/Comment.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = true,
    },
    { -- Center editor area
        "shortcuts/no-neck-pain.nvim",
        event = { "BufReadPre", "BufNewFile" },
        version = "*",
        config = function()
            vim.keymap.set("n", "\\cc", "<cmd>NoNeckPain<cr>", { noremap = true, silent = true })
        end,
    },
}
