-- General --------------------------------------------------------------------
vim.cmd('autocmd!')
vim.opt.title = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.conceallevel = 0  -- Makes `` is visible in markdown files
vim.opt.cursorline = true -- Highlight the current line
vim.opt.mouse = "a"       -- Allow the mouse to be used
vim.opt.laststatus = 2
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.inccommand = 'split'
vim.opt.backspace = 'start,eol,indent'
vim.opt.updatetime = 200             -- For CursorHold responsiveness
vim.opt.swapfile = false             -- No swap files
vim.opt.formatoptions:append { 'r' } -- Add asterisks in block comments
vim.opt.path:append { '**' }         -- Finding files - Seach down into subfolders
vim.wo.relativenumber = true         -- Line Numbers
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.backupskip = '/tmp/*,/private/tmp/*'
-- ============================================================================



-- Search ---------------------------------------------------------------------
vim.opt.hlsearch = true
vim.opt.ignorecase = true
-- ============================================================================


-- Indentation ----------------------------------------------------------------
vim.opt.ai = true    -- Auto Indent
vim.opt.si = true    -- Smart Indent
vim.opt.wrap = false -- No Wrap Lines
vim.opt.breakindent = true
vim.opt.shiftwidth = 4
vim.opt.colorcolumn = { 80 }
-- ============================================================================



-- <tab> Behavior -------------------------------------------------------------
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.tabstop = 4
-- ============================================================================



-- Undercurl ------------------------------------------------------------------
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
-- ============================================================================



-- Encodings ------------------------------------------------------------------
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
-- ============================================================================
