require('lze').load({
	{ import = 'config.plugins.cmp' },
	{ import = 'config.plugins.format' },
	{ import = 'config.plugins.snacks' },
	{ import = 'config.plugins.treesitter' },
	{ import = 'config.plugins.ui' },
	{
		'cellular-automaton.nvim',
		for_cat = 'general.fun',
		event = 'DeferredUIEnter',
	},
	{
		'comment.nvim',
		for_cat = 'general.utils',
		event = 'DeferredUIEnter',
		after = function(_)
			require('Comment').setup({})
		end,
	},
	{
		'harpoon',
		for_cat = 'general.utils',
		event = 'DeferredUIEnter',
		after = function(_)
			local ui = require('harpoon.ui')

			vim.keymap.set('n', '<leader>m', function()
				require('harpoon.mark').add_file()
			end, { desc = '[M]ark with harpoon' })
			vim.keymap.set('n', 'g1', function()
				ui.nav_file(1)
			end, { desc = 'Go to file 1' })
			vim.keymap.set('n', 'g2', function()
				ui.nav_file(2)
			end, { desc = 'Go to file 2' })
			vim.keymap.set('n', 'g3', function()
				ui.nav_file(3)
			end, { desc = 'Go to file 3' })
		end,
	},
	{
		'lazydev.nvim',
		for_cat = 'general.lsp',
		cmd = { 'LazyDev' },
		ft = 'lua',
		after = function(_)
			require('lazydev').setup({
				library = {
					{ words = { 'nixCats' }, path = (require('nixCats').nixCatsPath or '') .. '/lua' },
				},
			})
		end,
	},
	{
		'nvim-autopairs',
		for_cat = 'general.utils',
		event = 'InsertEnter',
		after = function(_)
			require('nvim-autopairs').setup({})
		end,
	},
	{
		'nvim-surround',
		for_cat = 'general.utils',
		event = 'DeferredUIEnter',
		after = function(_)
			require('nvim-surround').setup({})
		end,
	},
	{
		'project.nvim',
		for_cat = 'general.utils',
		event = 'DeferredUIEnter',
		after = function(_)
			require('project_nvim').setup({})
		end,
	},
	{
		'which-key.nvim',
		for_cat = 'general.binds',
		event = 'DeferredUIEnter',
		after = function(_)
			require('which-key').setup()
			require('which-key').add({
				{ '<leader>b', group = '[B]uffer', icon = { icon = '', hl = 'WhichKeyNormal' } },
				{ '<leader>s', group = '[S]earch', icon = { icon = '󰭎', hl = 'WhichKeyNormal' } },
				{ '<leader>g', group = '[G]it', icon = { icon = '', hl = 'WhichKeyNormal' } },
				{ '<leader>e', group = 'Diagnostic Messages', icon = { icon = '󱖫', hl = 'WhichKeyNormal' } },
				{ '<leader>F', group = '[F]ormat', icon = { icon = '󰉼', hl = 'WhichKeyNormal' } },
				{ '<leader>FF', icon = { icon = '󰈔', hl = 'WhichKeyNormal' } },
				{ '<leader>c', group = '[C]ode', icon = { icon = '', hl = 'WhichKeyNormal' } },
			})
		end,
	},
})
