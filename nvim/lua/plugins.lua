local status, lazy = pcall(require, "lazy")

if not status then
    print("Lazy is not installed")
    return
end

lazy.setup({
    "L3MON4D3/LuaSnip", -- Snippet

    -- Completion -------------------------------------------------------------
    "hrsh7th/nvim-cmp",     -- Completion Base
    "hrsh7th/cmp-buffer",   -- nvim-cmp source for buffer words
    "hrsh7th/cmp-nvim-lsp", -- nvim-cmp source for neovim's built-in LSP
    -- ========================================================================

    -- LSP --------------------------------------------------------------------
    "williamboman/mason.nvim",           -- LSP Installer
    "williamboman/mason-lspconfig.nvim", -- Plugin between mason and lspconfig
    "neovim/nvim-lspconfig",             -- LSP Base
    "onsails/lspkind-nvim",              -- VS Code like pictograms
    -- ========================================================================

    -- Git --------------------------------------------------------------------
    "lewis6991/gitsigns.nvim", -- Git signs on the gutter
    "dinhhuy258/git.nvim",     -- Git blame, diff
    -- ========================================================================

    -- Treesitter -------------------------------------------------------------
    "nvim-treesitter/nvim-treesitter",
    -- ========================================================================

    -- Telescope - Fuzzy Finder -----------------------------------------------
    "nvim-lua/plenary.nvim",         -- Lua utility functions, required by telescope
    "nvim-telescope/telescope.nvim", -- Telescope Base
    "nvim-telescope/telescope-file-browser.nvim",
    -- ========================================================================

    -- Colorscheme ------------------------------------------------------------
    "svrana/neosolarized.nvim",
    "tjdevries/colorbuddy.nvim",
    -- ========================================================================

    -- Other Utililities ------------------------------------------------------
    "windwp/nvim-autopairs",                          -- Pair brackets
    "windwp/nvim-ts-autotag",                         -- Pair html tags
    "norcalli/nvim-colorizer.lua",                    -- For previewing colors in files (css)
    "akinsho/nvim-bufferline.lua",                    -- To use tabs like buffers
    "nvim-lualine/lualine.nvim",                      -- Statusline
    "kyazdani42/nvim-web-devicons",                   -- Icons
    "terrortylor/nvim-comment",                       -- Toggle Comment
    { "shortcuts/no-neck-pain.nvim", version = "*" }, -- Center editor area
    "smjonas/inc-rename.nvim",                        -- Rename symbol
    -- ========================================================================

    -- Experimental -----------------------------------------------------------
    {
        "folke/noice.nvim", -- UI components
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    }

})
