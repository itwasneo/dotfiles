local status, packer = pcall(require, 'packer')

if (not status) then
    print("Packer is not installed")
    return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
    use 'wbthomason/packer.nvim' -- Package Installer

    use 'kyazdani42/nvim-web-devicons'
    use 'L3MON4D3/LuaSnip' -- Snippet
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    } -- Treesitter


    -- Completion -------------------------------------------------------------
    use 'hrsh7th/nvim-cmp'     -- Completion Base
    use 'hrsh7th/cmp-buffer'   -- nvim-cmp source for buffer words
    use 'hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for neovim's built-in LSP
    -- ========================================================================


    -- LSP --------------------------------------------------------------------
    use 'williamboman/mason.nvim'           -- LSP Installer
    use 'williamboman/mason-lspconfig.nvim' -- Plugin between mason and lspconfig
    use 'neovim/nvim-lspconfig'             -- LSP Base
    use 'onsails/lspkind-nvim'              -- VS Code like pictograms
    -- ========================================================================


    -- Git --------------------------------------------------------------------
    use 'lewis6991/gitsigns.nvim' -- Git signs on the gutter
    use 'dinhhuy258/git.nvim'     -- Git blame, diff
    -- ========================================================================


    -- Telescope - Fuzzy Finder -----------------------------------------------
    use 'nvim-lua/plenary.nvim'         -- Lua utility functions, required by telescope
    use 'nvim-telescope/telescope.nvim' -- Telescope Base
    use 'nvim-telescope/telescope-file-browser.nvim'
    -- ========================================================================


    -- Other Utililities ------------------------------------------------------
    use 'windwp/nvim-autopairs'       -- Pair brackets
    use 'windwp/nvim-ts-autotag'      -- Pair html tags
    use 'norcalli/nvim-colorizer.lua' -- For previewing colors in files (css)
    use 'akinsho/nvim-bufferline.lua' -- To use tabs like buffers
    use 'nvim-lualine/lualine.nvim'   -- Statusline
    -- ========================================================================


    -- Colorscheme ------------------------------------------------------------
    use { 'svrana/neosolarized.nvim',
        requires = { 'tjdevries/colorbuddy.vim' }
    } -- Solarized Dark all the way
    -- ========================================================================
end)
