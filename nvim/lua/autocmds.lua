require "nvchad.autocmds"

local qf_group = vim.api.nvim_create_augroup("QuickfixMappings", { clear = true })

local function qf_move_and_open(key)
  return function()
    local qf_win = vim.api.nvim_get_current_win()
    vim.cmd("normal! " .. key)
    vim.cmd "normal! \r"
    vim.cmd "normal! zz"

    -- Jump to the selected item, but keep focus in the quickfix/location list.
    if vim.api.nvim_win_is_valid(qf_win) then
      pcall(vim.api.nvim_set_current_win, qf_win)
    end
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(function()
      pcall(vim.cmd, "NvimTreeOpen")
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = qf_group,
  pattern = "qf",
  callback = function(args)
    vim.keymap.set("n", "<C-j>", qf_move_and_open "j", {
      buffer = args.buf,
      silent = true,
      desc = "Next quickfix item and jump",
    })

    vim.keymap.set("n", "<C-k>", qf_move_and_open "k", {
      buffer = args.buf,
      silent = true,
      desc = "Previous quickfix item and jump",
    })

    vim.keymap.set("n", "q", "<cmd>close<CR>", {
      buffer = args.buf,
      silent = true,
      desc = "Close quickfix/location list",
    })
  end,
})
