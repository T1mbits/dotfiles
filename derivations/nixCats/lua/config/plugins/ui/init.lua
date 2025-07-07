return {
	{ import = 'config.plugins.ui.alpha' },
	{ import = 'config.plugins.ui.text_decoration' },
	{ import = 'config.plugins.ui.lualine' },
	{ import = 'config.plugins.ui.telescope' },
	{
		'nvim-lightbulb',
		for_cat = 'general.ui.status',
		event = 'DeferredUIEnter',
		after = function(_)
			require('nvim-lightbulb').setup({
				priority = 101,
				autocmd = { enabled = true },
				sign = { enabled = false },
				virtual_text = { enabled = true, hl = 'NonText' },
			})
		end,
	},
	{
		'fidget.nvim',
		for_cat = 'general.ui.status',
		event = 'DeferredUIEnter',
		after = function(_)
			require('fidget').setup({
				notification = {
					override_vim_notify = true,
					window = {
						-- border = 'rounded',
						winblend = 0,
					},
				},
			})
		end,
	},
	{
		'gitsigns.nvim',
		for_cat = 'general.ui.status',
		event = 'DeferredUIEnter',
		after = function(_)
			require('gitsigns').setup({ signs_staged_enable = false })
		end,
	},
	{
		'render-markdown.nvim',
		for_cat = 'general.ui.misc',
		ft = 'markdown',
		after = function(_)
			require('render-markdown').setup({})
		end,
	},
	{
		'todo-comments.nvim',
		for_cat = 'general.ui.misc',
		event = 'DeferredUIEnter',
		after = function(_)
			require('todo-comments').setup({ signs = false })
		end,
	},
	{
		'transparent.nvim',
		for_cat = 'general.ui',
		after = function(_)
			vim.g.transparent_groups =
				vim.list_extend(vim.g.transparent_groups or {}, { 'TelescopeNormal', 'TelescopeBorder' })
		end,
	},
	{
		'bluloco.nvim',
		for_cat = 'general.ui',
		after = function(_)
			require('bluloco').setup({
				transparent = true,
			})

			vim.cmd('colorscheme bluloco')
		end,
	},
}
