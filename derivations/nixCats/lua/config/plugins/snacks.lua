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
				-- picker = {
				-- 	enabled = true,
				-- },
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
		end,
	},
}
