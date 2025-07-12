local load_with_after = function(name)
	vim.cmd.packadd(name)
	vim.cmd.packadd(name .. '/after')
end

return {
	{
		'colorful-menu.nvim',
		for_cat = 'general.completion',
		on_plugin = { 'blink.cmp' },
	},
	{
		'friendly-snippets',
		for_cat = 'general.completion',
		dep_of = { 'luasnip' },
	},
	{
		'luasnip',
		for_cat = 'general.completion',
		dep_of = { 'blink.cmp' },
		after = function(_)
			require('luasnip.loaders.from_vscode').lazy_load()
			local luasnip = require('luasnip')
			luasnip.config.setup()
		end,
	},
	{
		'cmp-cmdline',
		for_cat = 'general.completion',
		on_plugin = { 'blink.cmp' },
		load = load_with_after,
	},
	{
		'blink.compat',
		for_cat = 'general.completion',
		dep_of = { 'cmp-cmdline' },
	},
	{
		'blink.cmp',
		for_cat = 'general.completion',
		event = 'DeferredUIEnter',
		after = function(_)
			require('blink.cmp').setup({
				completion = {
					menu = {
						auto_show = false,
						draw = {
							components = {
								label = {
									text = function(ctx)
										return require('colorful-menu').blink_components_text(ctx)
									end,
									highlight = function(ctx)
										return require('colorful-menu').blink_components_highlight(ctx)
									end,
								},
							},
							treesitter = { 'lsp' },
						},
					},
					documentation = {
						auto_show = true,
					},
					ghost_text = {
						enabled = true,
						show_with_menu = false,
					},
				},
				cmdline = {
					enabled = true,
					completion = {
						menu = {
							auto_show = true,
						},
					},
					keymap = {
						preset = 'inherit',
						['<CR>'] = { 'fallback' },
						['<C-y>'] = { 'select_and_accept', 'fallback' },
					},
					sources = function()
						local type = vim.fn.getcmdtype()
						if type == '/' or type == '?' then
							return { 'buffer' }
						end
						if type == ':' or type == '@' then
							return { 'cmdline', 'cmp_cmdline' }
						end
						return {}
					end,
				},
				keymap = {
					preset = 'none',

					['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
					['<C-e>'] = { 'cancel' },

					['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
					['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

					['<CR>'] = { 'select_and_accept', 'fallback' },

					['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
					['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

					['<C-k>'] = { 'show_signature' },
				},
				signature = {
					enabled = true,
				},
				snippets = {
					preset = 'luasnip',
					active = function(_)
						local snippet = require('luasnip')
						local blink = require('blink.cmp')
						if snippet.in_snippet() and not blink.is_visible() then
							return true
						else
							if not snippet.in_snippet() and vim.fn.mode() == 'n' then
								snippet.unlink_current()
							end
							return false
						end
					end,
				},
				sources = {
					default = { 'lsp', 'path', 'snippets', 'buffer', 'omni' },
					providers = {
						cmp_cmdline = {
							name = 'cmp_cmdline',
							module = 'blink.compat.source',
						},
					},
				},
			})
		end,
	},
}
