return {
	filetypes = { "vue" },

	on_init = function(client)
		client.handlers["tsserver/request"] = function(_, result, context)
			-- Prefer vtsls, fallback to ts_ls
			local clients = vim.lsp.get_clients({
				bufnr = context.bufnr,
				name = "vtsls",
			})

			if #clients == 0 then
				clients = vim.lsp.get_clients({
					bufnr = context.bufnr,
					name = "ts_ls",
				})
			end

			if #clients == 0 then
				vim.notify(
					"Volar: could not find vtsls or ts_ls client",
					vim.log.levels.ERROR
				)
				return
			end

			local ts_client = clients[1]
			local id, command, payload = unpack(result)

			ts_client:exec_cmd(
				{
					title = "vue_request_forward",
					command = "typescript.tsserverRequest",
					arguments = {
						command,
						payload,
					},
				},
				{ bufnr = context.bufnr },
				function(_, r)
					local response = r and r.body
					local response_data = { { id, response } }

					---@diagnostic disable-next-line: param-type-mismatch
					client:notify("tsserver/response", response_data)
				end
			)
		end
	end,
}
