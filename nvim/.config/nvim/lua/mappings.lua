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

-- Git hunks in current buffer
map("n", "]h", function()
  require("gitsigns").nav_hunk("next", {}, function()
    vim.cmd "normal! zz"
  end)
end, { desc = "Next git hunk" })

map("n", "[h", function()
  require("gitsigns").nav_hunk("prev", {}, function()
    vim.cmd "normal! zz"
  end)
end, { desc = "Previous git hunk" })

map("n", "<leader>gh", function()
  require("gitsigns").setloclist(0, 0)
end, { desc = "Git hunks loclist current buffer" })

map("n", "<leader>gH", function()
  require("gitsigns").setqflist "all"
end, { desc = "Git hunks quickfix all files" })

map("n", "<leader>gp", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview git hunk" })

vim.api.nvim_create_user_command("GitHunks", function()
  require("gitsigns").setloclist(0, 0)
end, { desc = "List git hunks in current buffer" })

vim.api.nvim_create_user_command("BufCloseAll", function(opts)
  local skip_filetypes = {
    NvimTree = true,
    qf = true,
  }

  local buffers_to_close = {}
  local modified = {}

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buflisted and not skip_filetypes[vim.bo[bufnr].filetype] then
      table.insert(buffers_to_close, bufnr)

      if vim.bo[bufnr].modified then
        table.insert(modified, vim.api.nvim_buf_get_name(bufnr))
      end
    end
  end

  if #modified > 0 and not opts.bang then
    vim.notify("Unsaved buffers. Use :BufCloseAll! to force.", vim.log.levels.WARN)
    return
  end

  for _, bufnr in ipairs(buffers_to_close) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      pcall(vim.api.nvim_buf_delete, bufnr, { force = opts.bang })
    end
  end
end, {
  bang = true,
  desc = "Close all normal buffers; use ! to force unsaved buffers",
})

map("n", "<leader>bD", "<cmd>BufCloseAll<CR>", { desc = "Close all buffers" })

vim.api.nvim_create_user_command("FormatJson", "%!jq .", {})
