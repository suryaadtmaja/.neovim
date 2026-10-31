return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"folke/neoconf.nvim",
		"folke/neodev.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		require("neoconf").setup({})
		require("neodev").setup({})
		require("mason").setup()

		local server_settings = require("ide.lsp.servers")
		local mlsp = require("mason-lspconfig")

		mlsp.setup({
			ensure_installed = server_settings.default_servers,
		})

		for _, server_name in ipairs(mlsp.get_installed_servers()) do
			if not server_settings.is_disabled(server_name) then
				vim.lsp.config(
					server_name,
					server_settings.get_config(server_name)
				)

				vim.lsp.enable(server_name)
			end
		end

		require("ide.lsp.diagnostics").setup()
	end,
}
