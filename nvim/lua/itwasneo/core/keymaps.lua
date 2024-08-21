local keymap = vim.keymap

-- Do not yank with x
keymap.set("n", "x", '"_x')

-- Increment / Decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Tab
keymap.set("n", "te", ":tabnew<Return>", { silent = true })
keymap.set("n", "<Tab>", "<cmd>tabnext<cr>", { silent = true })
keymap.set("n", "<S-Tab>", "<cmd>tabprevious<cr>", { silent = true })

-- Split window
keymap.set("n", "ss", ":split<Return><C-w>w", { silent = true })
keymap.set("n", "sv", ":vsplit<Return><C-w>w", { silent = true })

-- Navigate windows
keymap.set("n", "<Space>", "<C-w>w")
keymap.set("", "s<left>", "<C-w>h")
keymap.set("", "s<up>", "<C-w>k")
keymap.set("", "s<down>", "<C-w>j")
keymap.set("", "s<right>", "<C-w>l")
keymap.set("", "sh", "<C-w>h")
keymap.set("", "sk", "<C-w>k")
keymap.set("", "sj", "<C-w>j")
keymap.set("", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Util
keymap.set("n", "<leader>f", ":Format<cr>", { silent = true })

-- Use space key instead of ':'
keymap.set("n", "<space>", ":")

-- Inc-rename shortcut
keymap.set("n", "<leader>rn", ":IncRename ")

-- Insert Date
keymap.set("n", "<leader>T", ":put =strftime('%a %Y-%m-%d %H:%M%z')<CR>")
keymap.set("n", "<leader>D", ":put =strftime('%a %b %d, %Y')<CR>")
