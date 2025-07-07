return {
	{
		'telescope.nvim',
		for_cat = 'general.ui.telescope',
		cmd = { 'Telescope' },
		on_require = { 'telescope' },
		keys = {
			{ '<leader>sb', mode = { 'n' }, desc = '[S]earch [B]uffers' },
			{ '<leader>sd', mode = { 'n' }, desc = '[S]earch [D]iagnostics' },
			{ '<leader>sf', mode = { 'n' }, desc = '[S]earch [F]iles' },
			{ '<leader>sg', mode = { 'n' }, desc = '[S]earch [G]rep' },
			{ '<leader>sk', mode = { 'n' }, desc = '[S]earch [K]eymaps' },
			{ '<leader>sm', mode = { 'n' }, desc = '[S]earch harpoon [M]arks' },
			{ '<leader>sp', mode = { 'n' }, desc = '[S]earch [P]rojects' },
			{ '<leader>sw', mode = { 'n' }, desc = '[S]earch [W]ord(s)' },
			{ '<leader>s/', mode = { 'n' }, desc = '[S]earch [/] in Open Files' },
			{ '<leader>/', mode = { 'n' }, desc = '[/] Fuzzy search buffer' },
		},
		load = function(name)
			vim.cmd.packadd(name)
			vim.cmd.packadd('telescope-fzf-native.nvim')
			vim.cmd.packadd('telescope-ui-select.nvim')
		end,
		after = function(_)
			require('telescope').setup({
				extensions = {
					['ui-select'] = {
						require('telescope.themes').get_cursor(),
					},
				},
			})

			require('telescope').load_extension('fzf')
			require('telescope').load_extension('projects')
			require('telescope').load_extension('harpoon')
			require('telescope').load_extension('ui-select')

			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
			vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
			vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
			vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch with [G]rep' })
			vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
			vim.keymap.set('n', '<leader>sm', function()
				require('telescope').extensions.harpoon.marks({})
			end, { desc = '[S]earch harpoon [M]arks' })
			vim.keymap.set('n', '<leader>sp', function()
				require('telescope').extensions.projects.projects({})
			end, { desc = '[S]earch [P]rojects' })
			vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch [W]ord(s)' })
			vim.keymap.set('n', '<leader>s/', function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = 'Live Grep in Open Files',
				})
			end, { desc = '[S]earch [/] in Open Files' })
			vim.keymap.set('n', '<leader>/', function()
				builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
					winblend = 0,
					previewer = false,
				}))
			end, { desc = '[/] Fuzzy search buffer' })
		end,
	},
}
