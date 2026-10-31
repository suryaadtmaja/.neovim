return {
	filetypes = { "astro", "javascript", "typescript", "react", "typescriptreact", "javascriptreact", "css", "scss", "sass", "html", "svelte", "vue" },
	settings = {
		tailwindCSS = {
			classAttributes = { "class", "className", "classList", "ngClass" },
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidScreen = "error",
				invalidVariant = "error",
				invalidConfigPath = "error",
				invalidTailwindDirective = "error",
				recommendedVariantOrder = "warning",
			},
			validate = true,
		},
	},
}