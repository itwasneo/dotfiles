require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
map("i", "<C-c>", "<Esc>", { noremap = true })
map("n", "<C-c>", "<Esc>", { noremap = true })

-- Diagnostic navigation (Neovim 0.10+ / 0.11+)
map("n", "<C-j>", function()
  vim.diagnostic.jump { count = 1 }
end, { desc = "Next diagnostic" })

map("n", "<C-k>", function()
  vim.diagnostic.jump { count = -1 }
end, { desc = "Previous diagnostic" })

vim.api.nvim_create_user_command('FormatJson', '%!jq .', {})
