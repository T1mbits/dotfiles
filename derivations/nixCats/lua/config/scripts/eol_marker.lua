local ignore_filetypes = {
	'alpha',
}
local ignore_buftypes = {
	'prompt',
	'terminal',
}

local ns_id = vim.api.nvim_create_namespace('eol markers')

local function get_visible_lines()
	return vim.fn.line('w0') - 1, vim.fn.line('w$')
end

local function show_eol_markers()
	if
		vim.fn.mode() ~= 'n'
		or vim.tbl_contains(ignore_filetypes, vim.bo.filetype)
		or vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
	then
		return
	end

	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)

	local top_visible_line, bottom_visible_line = get_visible_lines()
	local lines = vim.api.nvim_buf_get_lines(buf, top_visible_line, bottom_visible_line, false)

	for i, line in ipairs(lines) do
		if line ~= '' then
			local line_index = top_visible_line + i - 1
			vim.api.nvim_buf_set_extmark(buf, ns_id, line_index, -1, {
				virt_text = { { '↵', 'NonText' } },
				virt_text_pos = 'eol',
				hl_mode = 'combine',
				priority = 100,
			})
		end
	end
end

local function clear_eol_markers()
	vim.api.nvim_buf_clear_namespace(vim.api.nvim_get_current_buf(), ns_id, 0, -1)
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorMoved', 'WinScrolled' }, {
	callback = show_eol_markers,
})

vim.api.nvim_create_autocmd('InsertEnter', {
	callback = clear_eol_markers,
})

vim.api.nvim_create_autocmd('InsertLeave', {
	callback = show_eol_markers,
})
