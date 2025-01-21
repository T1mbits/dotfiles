---packadd + after/plugin
---@type fun(names: string[]|string)
local load_w_after_plugin = require('nixCatsUtils.lzUtils').make_load_with_after({ 'plugin' })

return {
	{
		'cmp-buffer',
		for_cat = 'general.cmp',
		on_plugin = { 'nvim-cmp' },
		load = load_w_after_plugin,
	},
	{
		'cmp-cmdline',
		for_cat = 'general.cmp',
		on_plugin = { 'nvim-cmp' },
		load = load_w_after_plugin,
	},
	{
		'cmp-luasnip',
		for_cat = 'general.cmp',
		on_plugin = { 'nvim-cmp' },
		load = load_w_after_plugin,
	},
	{
		'cmp-nvim-lsp',
		for_cat = 'general.cmp',
		on_plugin = { 'nvim-cmp' },
		load = load_w_after_plugin,
	},
	{
		'cmp-nvim-lsp-signature-help',
		for_cat = 'general.cmp',
		on_plugin = { 'nvim-cmp' },
		load = load_w_after_plugin,
	},
	{
		'cmp-nvim-lua',
		for_cat = 'general.cmp',
		on_plugin = { 'nvim-cmp' },
		load = load_w_after_plugin,
	},
	{
		'cmp-path',
		for_cat = 'general.cmp',
		on_plugin = { 'nvim-cmp' },
		load = load_w_after_plugin,
	},
	{
		'friendly-snippets',
		for_cat = 'general.cmp',
		dep_of = { 'nvim-cmp' },
	},
	{
		'lspkind.nvim',
		for_cat = 'general.cmp',
		dep_of = { 'nvim-cmp' },
		load = load_w_after_plugin,
	},
	{
		'luasnip',
		for_cat = 'general.cmp',
		dep_of = { 'nvim-cmp' },
		after = function(plugin)
			local ls = require('luasnip')
			require('luasnip.loaders.from_vscode').lazy_load()
			ls.config.setup()

			vim.keymap.set({ 'i', 's' }, '<M-n>', function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end)
		end,
	},
	{
		'nvim-cmp',
		for_cat = 'general.cmp',
		event = { 'DeferredUIEnter' },
		on_require = { 'cmp' },
		after = function(plugin)
			local cmp = require('cmp')
			local luasnip = require('luasnip')
			local lspkind = require('lspkind')

			cmp.setup({
				formatting = {
					format = lspkind.cmp_format({
						mode = 'text',
						with_text = true,
						maxwidth = 50,
						ellipsis_char = '...',
						menu = {
							buffer = '[BUF]',
							nvim_lsp = '[LSP]',
							nvim_lsp_signature_help = '[LSP]',
							nvim_lsp_document_symbol = '[LSP]',
							nvim_lua = '[API]',
							path = '[PATH]',
							luasnip = '[SNIP]',
						},
					}),
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete({ reason = cmp.ContextReason.Auto }),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				}),
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'nvim_lsp_signature_help' },
					{ name = 'path' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
				},
				enabled = function()
					return vim.bo[0].buftype ~= 'prompt'
				end,
				experimental = {
					ghost_text = true,
				},
			})

			cmp.setup.filetype('lua', {
				soruces = cmp.config.sources({
					{ name = 'nvim_lua' },
					{ name = 'nvim_lsp' },
					{ name = 'nvim_lsp_signature_help' },
					{ name = 'path' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
				}),
				{
					{
						name = 'cmdline',
						option = {
							ignore_cmds = { 'Man', '!' },
						},
					},
				},
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'nvim_lsp_document_symbol' },
					{ name = 'buffer' },
				},
				view = {
					entries = { name = 'wildmenu', separator = '|' },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'cmdline' },
					{ name = 'path' },
				}),
			})
		end,
	},
}
