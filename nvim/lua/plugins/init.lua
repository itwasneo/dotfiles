return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "scalameta/nvim-metals",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "scala", "sbt" },
    config = function()
      require("configs.metals").setup()
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
    ft = { "markdown" },
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = require "configs.render-markdown",
  },

  -- {
  --   "mfussenegger/nvim-jdtls",
  --   ft = { "java" },
  -- },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
    "nvim-tree/nvim-tree.lua",
    opts = require("configs.nvimtree").opts,
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = require("configs.gitsigns").opts,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "vim",
        "vimdoc",
        "html",
        "css",
        "lua",
        "rust",
        "scala",
        "markdown",
        "markdown_inline",
      },
    },
  },
}
