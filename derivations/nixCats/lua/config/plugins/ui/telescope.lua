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
			{ '<leader>sh', mode = { 'n' }, desc = '[S]earch [H]arpoon Files' },
			-- { '<leader>sp', mode = { 'n' }, desc = '[S]earch [P]rojects' },
			{ '<leader>sw', mode = { 'n' }, desc = '[S]earch [W]ord(s)' },
			{ '<leader>s/', mode = { 'n' }, desc = '[S]earch [/] in Open Files' },
			{ '<leader>/', mode = { 'n' }, desc = '[/] Fuzzy search buffer' },
			{ 'gR', mode = { 'n' }, desc = 'LSP: [G]oto [R]eferences' },
			{ 'gI', mode = { 'n' }, desc = 'LSP: [G]oto [I]mplentation' },
			{ '<leader>ds', mode = { 'n' }, desc = 'LSP: [D]ocument [S]ymbols' },
			{ '<leader>ws', mode = { 'n' }, desc = 'LSP: [W]orkspace [S]ymbols' },
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

			local function harpoon_telescope(harpoon_files)
				local conf = require('telescope.config').values

				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require('telescope.pickers')
					.new({}, {
						prompt_title = 'Harpoon',
						finder = require('telescope.finders').new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			require('telescope').load_extension('fzf')
			-- require('telescope').load_extension('projects')
			require('telescope').load_extension('ui-select')

			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
			vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
			vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
			vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch with [G]rep' })
			vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
			vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch [W]ord(s)' })

			vim.keymap.set('n', '<leader>sh', function()
				harpoon_telescope(require('harpoon'):list())
			end, { desc = '[S]earch [H]arpoon Files' })
			--[[ vim.keymap.set('n', '<leader>sp', function()
				require('telescope').extensions.projects.projects({})
			end, { desc = '[S]earch [P]rojects' }) ]]
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

			vim.keymap.set('n', 'gr', function()
				builtin.lsp_references()
			end, { desc = 'LSP: [G]oto [R]eferences' })
			vim.keymap.set('n', 'gI', function()
				builtin.lsp_implementations()
			end, { desc = 'LSP: [G]oto [I]mplementation' })
			vim.keymap.set('n', '<leader>ds', function()
				builtin.lsp_document_symbols()
			end, { desc = 'LSP: [D]ocument [S]ymbols' })
			vim.keymap.set('n', '<leader>ws', function()
				builtin.lsp_dynamic_workspace_symbols()
			end, { desc = 'LSP: [W]orkspace [S]ymbols' })
		end,
	},
}
