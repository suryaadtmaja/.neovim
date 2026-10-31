local vue_language_server_path = vim.fn.stdpath("data")
		.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local vue_plugin = {
	name = '@vue/typescript-plugin',
	location = vue_language_server_path,
	languages = { 'vue' },
	configNamespace = 'typescript',
}

return {
	on_attach = function(client, bufnr)
		require("twoslash-queries").attach(client, bufnr)
	end,
	typescript = {
		tsdk = vim.fn.stdpath("data") .. "/mason/packages/vtsls/node_modules/typescript/lib",
	},
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					vue_plugin,
				},
			},
		},
	},
	filetypes = {
		"typescript",
		"javascript",
		"javascriptreact",
		"typescriptreact",
		"vue"
	},
}
