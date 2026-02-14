require("nvchad.configs.lspconfig").defaults()

local servers = {
  "clangd",
  "rust_analyzer",
  "marksman",
  "neocmakelsp",
  "basedpyright",
  "ruff",
  -- "html",
  -- "cssls"
}
vim.lsp.enable(servers)

-- rust_analyzer
vim.lsp.config.rust_analyzer = {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}

-- Further configuration for clangd
vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    -- "-std=c++23",
    "--clang-tidy",
    "--completion-style=detailed",
    "--background-index",
    "--fallback-style=llvm",
    "--header-insertion=iwyu",
    "--header-insertion-decorators",
    "--pch-storage=memory",
    "--log=error",
    -- "-D__ARM_NEON__",
    -- "-I/opt/homebrew/include", -- Homebrew libs (TBB, fmt, etc.)
  },
  root_dir = vim.fs.root(0, {
    ".clangd",
    "compile_commands.json",
    "compile_flags.txt",
    "CMakeLists.txt",
  }),
  filetypes = { "c", "cpp" },
}

-- another cmake lsp
vim.lsp.config.neocmakelsp = {
  cmd = { "neocmakelsp", "stdio" },
  filetypes = { "cmake" },
  root_dir = vim.fs.root(0, {
    "CMakePresets.json",
    "CTestConfig.cmake",
    ".git",
    "build",
    "cmake",
  }),
  single_file_support = true,
  init_options = {
    format = {
      enable = true,
    },
    scan_cmake_in_package = true,
  },
}

-- Python (Basedpyright) Configuration
vim.lsp.config.basedpyright = {
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard", -- or "all" for strict backend dev
      },
    },
  },
}

-- Ruff (Fast Linter/Formatter)
vim.lsp.config.ruff = {
  -- Use ruff for organizing imports and fixing lint errors on the fly
  init_options = {
    settings = {
      args = {},
    },
  },
}

-- read :h vim.lsp.config for changing options of lsp servers
