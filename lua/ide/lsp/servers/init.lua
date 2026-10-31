local M = {}

-- list of servers that I always want installed
M.default_servers = {
	"html",
	"cssls",
	"svelte",
	"lua_ls",
	"gopls",
	"jsonls",
	"emmet_ls",
	"denols",
	"vtsls",
	"volar",
	"astro",
	"tailwindcss",
}

local server_settings = {
	emmet_ls = require("ide.lsp.servers.emmet_ls"),
	vue_ls = require("ide.lsp.servers.volar"),
	lua_ls = require("ide.lsp.servers.lua_ls"),
	jsonls = require("ide.lsp.servers.jsonls"),
	gopls = require("ide.lsp.servers.gopls"),
	vtsls = require("ide.lsp.servers.vtsls"),
	astro = require("ide.lsp.servers.astro"),
	tailwindcss = require("ide.lsp.servers.tailwindcss"),
}

M.is_disabled = function(server_name)
	if server_name == "ts_ls" or server_name == "tsserver" or server_name == "denols" then
		return true
	end

	local neoconf = require("neoconf")
	return neoconf.get(server_name .. ".disable")
end

-- M.is_disabled = function(server_name)
-- 	local neoconf = require("neoconf")

-- 	if server_name == "denols" then
-- 		return not neoconf.get("ts_ls.disable")
-- 				or not neoconf.get("denols.enable")
-- 	end

-- 	return neoconf.get(server_name .. ".disable")
-- end

local default_capabilities =
		require("cmp_nvim_lsp").default_capabilities()

local lsp_attach = function(client, bufnr)
	-- local surround_helper = function(cmd)
	-- 	return string.format("<cmd>lua vim.lsp.%s<cr>", cmd)
	-- end

	local opts = { buffer = bufnr, silent = true }
	-- --- 1. Quick Navigation (No leader needed) ---
	-- These are standard and rarely conflict
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
	vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)

	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	-- --- 2. Actions & Refactoring (Use <leader>) ---
	-- Using <leader>r for Rename (replaced 's')

	vim.keymap.set("n", "<leader>rn", function()
		vim.lsp.buf.rename()
	end, { buffer = bufnr, silent = true, desc = "Rename" })

	-- --- 2. Code Actions (The Telescope Fix) ---
	-- This replaces the "nothing happens/Insert mode" bug with a stable menu
	vim.keymap.set("n", "<leader>la", "<cmd>Telescope lsp_code_actions<cr>", opts)

	-- --- 3. Inlay Hints (The "IDE" View) ---
	if client.supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	-- --- 3. Diagnostics (Error handling) ---
	-- Show line diagnostics in a float
	vim.keymap.set("n", "<leader>d", function()
		vim.diagnostic.open_float({
			scope = "cursor",
			focusable = false,
			border = "rounded"
		})
	end, opts)
	-- Jump between errors
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

	vim.keymap.set("n", "gz", function()
		-- We save the current view to prevent the cursor from jumping
		local view = vim.fn.winsaveview()

		-- We wrap this in a pcall (protected call)
		-- This prevents the red error message from popping up if the indent logic fails
		local status, err = pcall(function()
			require("twoslash-queries").add_query(vim.api.nvim_win_get_cursor(0))
		end)

		if not status then
			-- If it failed, it's usually because of that HtmlIndent bug.
			-- We can try to attach it manually without the plugin's indent check
			-- or just notify the user quietly.
			vim.notify("Twoslash: Indent detection failed, but query might still work.", vim.log.levels.WARN)
		end

		vim.fn.winrestview(view)
	end, { buffer = bufnr, desc = "Twoslash Inspect" })

	-- Clear all virtual type annotations in the current buffer
	vim.keymap.set("n", "gZ", function()
		require("twoslash-queries").remove_queries()
	end, { buffer = bufnr, desc = "Twoslash Remove All" })

	-- Search for symbols in the CURRENT file
	vim.keymap.set("n", "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>",
		{ buffer = bufnr, desc = "Document Symbols" })

	-- Search for symbols in the WHOLE project (Workspace)
	-- This is how you find TableOptions from anywhere!
	vim.keymap.set("n", "<leader>sw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
		{ buffer = bufnr, desc = "Workspace Symbols" })
end

M.get_config = function(server_name)
	local specific_config = server_settings[server_name] or {}
	local specific_on_attach = specific_config.on_attach

	-- We create a custom function that runs BOTH attaches
	local combined_on_attach = function(client, bufnr)
		-- 1. Run your global keymaps (gd, gz, telescope, etc.)
		lsp_attach(client, bufnr)

		-- 2. Run the specific server attach (like Twoslash in vtsls.lua)
		if specific_on_attach then
			specific_on_attach(client, bufnr)
		end
	end

	-- Now we merge everything safely
	local final_config = vim.tbl_deep_extend("force", {}, specific_config)
	final_config.on_attach = combined_on_attach
	final_config.capabilities = default_capabilities

	return final_config
end

return M
