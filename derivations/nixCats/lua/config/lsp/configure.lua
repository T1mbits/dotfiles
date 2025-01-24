return {
	on_attach = function(_, bufnr)
		local nmap = function(keys, func, desc)
			if desc then
				desc = 'LSP: ' .. desc
			end
			vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
		end

		nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
		nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
		nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
		nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
		nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
		nmap('<leader>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, '[W]orkspace [L]ist Folders')
		nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
		nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
		nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
		nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

		local t_builtin = require('telescope.builtin')
    	-- stylua: ignore start
    	nmap('gr', function() t_builtin.lsp_references() end, '[G]oto [R]eferences')
    	nmap('gI', function() t_builtin.lsp_implementations() end, '[G]oto [I]mplementation')
    	nmap('<leader>ds', function() t_builtin.lsp_document_symbols() end, '[D]ocument [S]ymbols')
    	nmap('<leader>ws', function() t_builtin.lsp_dynamic_workspace_symbols() end, '[W]orkspace [S]ymbols')
		-- stylua: ignore end

		-- Show diagnostics on hover
		vim.api.nvim_create_autocmd('CursorHold', {
			buffer = bufnr,
			callback = function()
				local opts = {
					focusable = false,
					close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
					border = 'rounded',
					source = 'always',
					prefix = ' ',
					scope = 'cursor',
				}
				vim.diagnostic.open_float(nil, opts)
			end,
		})
		-- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		--   vim.lsp.buf.format()
		-- end, { desc = 'Format current buffer with LSP' })
	end,
	capabilities = function(server_name)
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end,
}
