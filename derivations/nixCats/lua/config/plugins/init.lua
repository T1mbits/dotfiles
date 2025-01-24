-- TODO help me
require('lze').load({
	{ import = 'config.plugins.telescope' },
	{ import = 'config.plugins.treesitter' },
	{ import = 'config.plugins.cmp' },
	{ import = 'config.plugins.alpha' },
	{ import = 'config.plugins.indent_blankline' },
	{ import = 'config.plugins.lualine' },
	{
		'cellular-automaton.nvim',
		for_cat = 'general.fun',
		event = 'DeferredUIEnter',
	},
	{
		'comment.nvim',
		for_cat = 'general.utils',
		event = 'DeferredUIEnter',
		after = function(plugin)
			require('Comment').setup({})
		end,
	},
	{
		'dressing.nvim',
		for_cat = 'general.ui',
		event = 'DeferredUIEnter',
	},
	{
		'fidget.nvim',
		for_cat = 'general.ui',
		event = 'DeferredUIEnter',
		after = function(plugin)
			require('fidget').setup({})
		end,
	},
	{
		'gitsigns.nvim',
		for_cat = 'general.ui',
		event = 'DeferredUIEnter',
		after = function(plugin)
			require('gitsigns').setup({ signs_staged_enable = false })
		end,
	},
	{
		'harpoon',
		for_cat = 'general.utils',
		event = 'DeferredUIEnter',
		after = function(plugin)
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
		after = function(plugin)
			require('lazydev').setup({
				library = {
					{ words = { 'nixCats' }, path = (require('nixCats').nixCatsPath or '') .. '/lua' },
				},
			})
		end,
	},
	{
		'render-markdown.nvim',
		for_cat = 'general.ui',
		ft = 'markdown',
		after = function(plugin)
			require('render-markdown').setup({})
		end,
	},
	{
		'nvim-autopairs',
		for_cat = 'general.utils',
		event = 'InsertEnter',
		after = function(plugin)
			require('nvim-autopairs').setup({})
		end,
	},
	{
		'nvim-surround',
		for_cat = 'general.utils',
		event = 'DeferredUIEnter',
		after = function(plugin)
			require('nvim-surround').setup({})
		end,
	},
	{
		'project.nvim',
		for_cat = 'general.utils',
		event = 'DeferredUIEnter',
		after = function(plugin)
			require('project_nvim').setup({})
		end,
	},
	{
		'todo-comments.nvim',
		for_cat = 'general.ui',
		event = 'DeferredUIEnter',
		after = function(plugin)
			require('todo-comments').setup({})
		end,
	},
	{
		'which-key.nvim',
		for_cat = 'general.binds',
		event = 'DeferredUIEnter',
		after = function(plugin)
			require('which-key').setup()
			require('which-key').add({
				{ '<leader>b', group = '[B]uffer', icon = { icon = '' } },
				{ '<leader>s', group = '[S]earch', icon = { icon = '󰭎' } },
				{ '<leader>g', group = '[G]it', icon = { icon = '' } },
			})
		end,
	},
})
