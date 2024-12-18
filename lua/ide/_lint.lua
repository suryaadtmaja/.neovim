return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")
		-- attach linters for filetypes
		lint.linters_by_ft = {
			css = { "stylelint" },
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			vue = { "eslint_d" },
			svelte = { "eslint_d" },
			go = { "golangcilint" }
		}
		-- setup lua autocommand to lint when first opening, after inserting and when writing the buffer.
		-- vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost", "BufEnter" }, {
		-- 	callback = function()
		-- 		require("lint").try_lint()
		-- 		-- require("lint").try_lint(nil, { ignore_errors = true })
		-- 	end,
		-- })
		vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost", "BufEnter" }, {
			callback = function()
				local ok, err = pcall(function()
					require("lint").try_lint()
				end)
				if not ok then
					vim.notify("Linting error: " .. err, vim.log.levels.ERROR)
				end
			end,
		})

		vim.api.nvim_create_user_command("Lint", function()
			require("lint").try_lint()
		end, {})
	end,
}
