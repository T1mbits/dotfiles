return {
	{
		'snacks.nvim',
		for_cat = 'general.snacks',
		event = 'DeferredUIEnter',
		after = function()
			require('snacks').setup({
				input = {
					enabled = true,
				},
				notifier = {
					enabled = true,
				},
				styles = {
					input = {
						title_pos = 'left',
						width = 40,
						relative = 'cursor',
						row = -3,
						col = 0,
					},
				},
			})

			vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, {
				'SnacksNotifierBorderError',
				'SnacksNotifierBorderWarn',
				'SnacksNotifierBorderInfo',
				'SnacksNotifierBorderDebug',
				'SnacksNotifierBorderTrace',
			})
		end,
	},
}
