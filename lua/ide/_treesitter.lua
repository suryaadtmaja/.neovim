return {
	"nvim-treesitter/nvim-treesitter",
	-- get correct commentstring before commenting (configured line 18-20)
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	build = ":TSUpdate",
	config = function()
		vim.g.skip_ts_context_commentstring_module = true
		vim.cmd([[autocmd BufRead,BufEnter *.astro set filetype=astro]])
		require("nvim-treesitter.configs").setup({
			modules = {},
			auto_install = true,
			ensure_installed = "all",
			-- disable because they throw errors I don't understand
			ignore_install = { "phpdoc", "markdown_inline", "cpp" },
			sync_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				-- this indentation currently over indents after closing a tag
				enable = false,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<c-space>',
					node_incremental = '<c-space>',
					scope_incremental = '<c-s>',
					node_decremental = '<M-space>',
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						['aa'] = '@parameter.outer',
						['ia'] = '@parameter.inner',
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						['ac'] = '@class.outer',
						['ic'] = '@class.inner',
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						[']m'] = '@function.outer',
						[']]'] = '@class.outer',
					},
					goto_next_end = {
						[']M'] = '@function.outer',
						[']['] = '@class.outer',
					},
					goto_previous_start = {
						['[m'] = '@function.outer',
						['[['] = '@class.outer',
					},
					goto_previous_end = {
						['[M'] = '@function.outer',
						['[]'] = '@class.outer',
					},
				},
				swap = {
					enable = true,
					swap_next = {
						['<leader>a'] = '@parameter.inner',
					},
					swap_previous = {
						['<leader>A'] = '@parameter.inner',
					},
				},
			},
		})
	end,
}
