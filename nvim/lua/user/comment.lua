local M = {
    "numToStr/Comment.nvim",
    lazy = false,
}

function M.config()
    require("Comment").setup {
        padding = true,
        sticky = true,
        toggler = {
            line = "gcc",
            block = "gbc",
        },
		opleader = {
			line = "gc",
			block = "gb",
		}
    }
end

return M
