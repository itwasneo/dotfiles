local status, n = pcall(require, "neosolarized")
if not status then
    return
end
n.setup({ comment_italics = true })

-- Changing higlight groups of Floating windows ---------------------------------
vim.api.nvim_command("highlight NormalFloat guifg=#586e75 guibg=#002b36")
vim.api.nvim_command("highlight FloatBorder guifg=#586e75")
-- ============================================================================

-- Defining highlight groups for LSP symbol highlighting -----------------------
vim.api.nvim_command("highlight LspReferenceWrite guibg=#014759")
vim.api.nvim_command("highlight LspReferenceText guibg=#014759")
vim.api.nvim_command("highlight LspReferenceRead guibg=#014759")
-- ============================================================================

-- Defining highlight groups for LSP error/warn underline
vim.api.nvim_command("highlight DiagnosticUnderlineError guisp=#dc322f")
vim.api.nvim_command("highlight DiagnosticUnderlineWarn guisp=#b58900")
vim.api.nvim_command("highlight DiagnosticUnderlineInfo guisp=#268bd2")
vim.api.nvim_command("highlight DiagnosticUnderlineHint guisp=#2aa198")

-- Cursor Line color ----------------------------------------------------------
vim.api.nvim_command("highlight CursorLine guibg=#002b36")
vim.api.nvim_command("highlight CursorLineNr guibg=#014759 guifg=#eee8d5")
-- ============================================================================
