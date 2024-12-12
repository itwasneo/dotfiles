return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup {
			ensure_installed = {
				"lua",
				"markdown",
				"markdown_inline",
				"bash",
				"kotlin",
			},
			indent = { enable = true } -- experimental feature
		}
	end
}
