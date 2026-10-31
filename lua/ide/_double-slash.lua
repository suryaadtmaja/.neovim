return {
	"marilari88/twoslash-queries.nvim",
	config = function()
		require("twoslash-queries").setup({
			multi_line = true, -- to print types in multi line mode
			highlight = "Type", -- to set up a highlight group for the virtual text
		})
	end
}
