return {
	{
		'nvim-treesitter',
		for_cat = 'general.treesitter',
		event = 'DeferredUIEnter',
		load = function(name)
			vim.cmd.packadd(name)
		end,
		after = function(plugin)
			require('nvim-treesitter.configs').setup({
				highlight = { enable = true },
				indent = { enable = false },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = '<c-space>',
						node_incremental = '<c-space>',
						scope_incremental = '<c-s>',
						node_decremental = '<M-space>',
					},
				},
			})
		end,
	},
}
