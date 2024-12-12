return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
	},
	config = function()
		require("mason").setup {
			ui = {
				border = "solid",
			}
		}
		require("mason-lspconfig").setup {
			ensure_installed = {
				"lua_ls",
				"jsonls",
			}
		}
	end
}
