local M = {
	"ThePrimeagen/harpoon",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim" }
	}
}

function M.config()
	local keymap = vim.keymap.set
	local opts = { noremap = true, silent = true }

	keymap("n", "<s-m>", "<cmd>lua require('user.harpoon').mark_file()<CR>", opts)
	keymap("n", "<TAB>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)

end

function M.mark_file()
	require("harpoon.mark").add_file()
	vim.notify "MARKED FILE"
end

return M
