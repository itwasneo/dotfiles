-- KEEP IT SIMPLE STUPID
vim.opt.backup = false -- don't create backup file
vim.opt.clipboard = "unnamedplus" -- allows neovim to access system clipboard
vim.opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.mouse = "a" -- allow mouse to be used in neovim
vim.opt.pumheight = 10 -- popup menu height
vim.opt.pumblend = 0
vim.opt.showmode = false -- don't show the current mode
vim.opt.showtabline = 1 -- always show tabs
vim.opt.smartcase = true -- smart case
vim.opt.smartindent = true
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go right of current window
vim.opt.swapfile = false -- don't create a swap file
vim.opt.termguicolors = true
vim.opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true -- enable persistent undo
vim.opt.updatetime = 100 -- faster completion (4000ms default)
vim.opt.writebackup = false -- if a file is being edited by another program
vim.opt.expandtab = false -- convert tabs to spaces
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4 -- insert 4 spaces for a tab
vim.opt.cursorline = true -- highlight the current line
vim.opt.number = true -- set numbered lines
vim.opt.laststatus = 3
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.numberwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false -- display lines as one long line
vim.opt.scrolloff = 0
vim.opt.sidescrolloff = 8
vim.opt.title = false
vim.opt.fillchars = vim.opt.fillchars + "eob: "
vim.opt.fillchars:append {
	stl = " ",
}
vim.opt.shortmess:append "c"
vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.g.netrw_banner = 0
vim.g.netrw_mouse = 2
