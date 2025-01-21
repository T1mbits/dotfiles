local clients_lsp = function()
	local bufnr = vim.api.nvim_get_current_buf()

	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if next(clients) == nil then
		return ''
	end

	local c = {}
	for _, client in pairs(clients) do
		table.insert(c, client.name)
	end
	-- Should only ever be one, but idk maybe there's two active LSPs for one buffer, I wanna know
	return ' lsp: ' .. table.concat(c, ' | ')
end

return {
	{
		'lualine.nvim',
		after = function()
			require('lualine').setup({
				sections = {
					lualine_a = {
						{
							'mode',
							fmt = function(mode)
								return string.lower(mode)
							end,
						},
					},
					lualine_b = { 'branch', { 'diff', colored = true } },
					lualine_c = { clients_lsp, 'diagnostics' },
					lualine_x = {
						'filename',
						'filetype',
					},
					lualine_y = { 'searchcount', 'progress' },
					lualine_z = { 'location' },
				},
			})
		end,
	},
}
