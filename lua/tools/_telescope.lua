local getVisualSelection = function()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ""
	end
end

return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
      "nvim-treesitter/nvim-treesitter",
      {
        "Theo-Steiner/togglescope",
        -- uncomment to use from ~projects/togglescope
        -- dev = true
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          -- require('telescope.builtin').oldfiles({ desc = '[?] Find recently opened files' })
          require('telescope.builtin').oldfiles()
        end,
      },
      -- use <leader> fc to search for merge conflicts
      { "<leader>fc", "<cmd>Telescope grep_string search=<<<<<<<<cr>", silent = true },
      {
        "<leader>sg",
        function()
          require("telescope").extensions.togglescope.live_grep({
            additional_args = {
              "-g",
              "!*-lock.*",
            },
            default_text = getVisualSelection(),
          })
        end,
        silent = true,
        mode = { "n", "v" },
      },
      {
        "<leader>sw",
        function ()
          require("telescope.builtin").grep_string({desc = "[S]search current [W]ord"})
        end
      }
    },
    config = function()
      local telescope = require("telescope")
      local actions = require 'telescope.actions'
      local function telescope_buffer_dir()
        return vim.fn.expand '%:p:h'
      end
      local config = {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
            n = {
              ['q'] = actions.close,
            },
          },
        },
        extensions = {
          togglescope = {
            find_files = {
              ["<C-^>"] = {
                no_ignore = true,
                hidden = true,
                togglescope_title = "Find Files (hidden)",
              },
            },
            live_grep = {
              ["<C-^>"] = {
                additional_args = {
                  "--no-ignore",
                  "--hidden",
                },
                togglescope_title = "Live Grep (hidden)",
              },
            },
          },
          file_browser = {
            theme = 'ivy',
            hijack_netrw = true,
            mappings = {
              -- your custom insert mode mappings
              ['i'] = {
                ['<C-w>'] = function()
                  vim.cmd 'normal vbd'
                end,
              },
              ['n'] = {
                -- your custom normal mode mappings
                -- ["N"] = fb_actions.create,
                -- ["h"] = fb_actions.goto_parent_dir,
                ['/'] = function()
                  vim.cmd 'startinsert'
                end,
              },
            },
          },
        },
      }
      telescope.setup(config)
    end,
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  } 
}
