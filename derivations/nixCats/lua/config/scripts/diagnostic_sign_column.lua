vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'CursorMoved', 'DiagnosticChanged', 'WinScrolled' }, {
	callback = function(args)
		local bufnr = args.buf

		if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
			return
		end

		local ns_id = vim.api.nvim_create_namespace('line number diagnostics')

		vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

		local hl_groups = {
			[vim.diagnostic.severity.ERROR] = 'DiagnosticError',
			[vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
			[vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
			[vim.diagnostic.severity.HINT] = 'DiagnosticHint',
		}
		local severity_order = {
			[vim.diagnostic.severity.ERROR] = 1,
			[vim.diagnostic.severity.WARN] = 2,
			[vim.diagnostic.severity.INFO] = 3,
			[vim.diagnostic.severity.HINT] = 4,
		}

		local top_visible_line = vim.fn.line('w0') - 1
		local bottom_visible_line = vim.fn.line('w$')

		local most_severe = {}
		for _, diagnostic in ipairs(vim.diagnostic.get(bufnr)) do
			local lnum = diagnostic.lnum

			if lnum < top_visible_line or lnum > bottom_visible_line then
				goto continue
			end

			local severity = diagnostic.severity
			local prev = most_severe[lnum]

			if not prev or severity_order[severity] < severity_order[prev] then
				most_severe[lnum] = severity
			end
			::continue::
		end

		for lnum, severity in pairs(most_severe) do
			local hl_group = hl_groups[severity]

			vim.api.nvim_buf_set_extmark(bufnr, ns_id, lnum, 0, {
				hl_group = hl_group,
				number_hl_group = hl_group,
				priority = 100,
			})
		end
	end,
})
