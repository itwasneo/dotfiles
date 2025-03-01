local M = {
    "nvim-lualine/lualine.nvim",
}

function M.config()
    require("lualine").setup {
		options = {
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = {},
			lualine_b = { "branch" },
			lualine_c = { "diagnostics" },
			lualine_x = { "filetype" },
			lualine_y = { "progress" },
			lualine_z = {}

		},
		extensions = { "quickfix", "man", "fugitive" },
	}
end

return M
