local function create_indent_autocmds(settings)
	vim.api.nvim_create_augroup('SetTabSettings', { clear = true })

	for _, setting in ipairs(settings) do
		vim.api.nvim_create_autocmd('FileType', {
			group = 'SetTabSettings',
			pattern = setting.pattern,
			callback = function()
				vim.bo.tabstop = setting.tabstop
				vim.bo.shiftwidth = setting.shiftwidth
				vim.bo.expandtab = setting.expandtab
			end,
		})
	end
end

create_indent_autocmds({
	{
		pattern = { 'cs', 'rust', 'javascript', 'typescript', 'typescriptreact' },
		tabstop = 4,
		shiftwidth = 4,
		expandtab = true,
	},
	{
		pattern = { 'lua', 'python' },
		tabstop = 4,
		shiftwidth = 4,
		expandtab = false,
	},
	{
		pattern = { 'nix' },
		tabstop = 2,
		shiftwidth = 2,
		expandtab = true,
	},
})
