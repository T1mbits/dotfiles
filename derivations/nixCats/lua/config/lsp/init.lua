-- NOTE: This file uses lzextras.lsp handler https://github.com/BirdeeHub/lzextras?tab=readme-ov-file#lsp-handler
-- This is a slightly more performant fallback function
-- for when you don't provide a filetype to trigger on yourself.
-- nixCats gives us the paths, which is faster than searching the rtp!
local old_ft_fallback = require('lze').h.lsp.get_ft_fallback()
require('lze').h.lsp.set_ft_fallback(function(name)
	local lspcfg = nixCats.pawsible({ 'allPlugins', 'opt', 'nvim-lspconfig' })
		or nixCats.pawsible({ 'allPlugins', 'start', 'nvim-lspconfig' })
	if lspcfg then
		local ok, cfg = pcall(dofile, lspcfg .. '/lsp/' .. name .. '.lua')
		if not ok then
			ok, cfg = pcall(dofile, lspcfg .. '/lua/lspconfig/configs/' .. name .. '.lua')
		end
		return (ok and cfg or {}).filetypes or {}
	else
		return old_ft_fallback(name)
	end
end)

require('lze').load({
	{
		'nvim-lspconfig',
		for_cat = 'general.lsp',
		on_require = { 'lspconfig' },
		lsp = function(plugin)
			vim.lsp.config(plugin.name, plugin.lsp or {})
			vim.lsp.enable(plugin.name)
		end,
		before = function(_)
			vim.lsp.config('*', {
				on_attach = require('config.lsp.on_attach'),
			})
		end,
	},
	{
		-- name of the lsp
		'lua_ls',
		for_cat = 'neonixdev',
		-- provide a table containing filetypes,
		-- and then whatever your functions defined in the function type specs expect.
		-- in our case, it just expects the normal lspconfig setup options,
		-- but with a default on_attach and capabilities
		lsp = {
			-- if you provide the filetypes it doesn't ask lspconfig for the filetypes
			filetypes = { 'lua' },
			settings = {
				Lua = {
					formatters = {
						ignoreComments = true,
					},
					signatureHelp = { enabled = true },
					diagnostics = {
						globals = { 'nixCats', 'vim' },
						disable = { 'missing-fields' },
					},
				},
				telemetry = { enabled = false },
				filetypes = { 'lua' },
			},
		},
	},
	{
		'nixd',
		for_cat = 'neonixdev',
		lsp = {
			filetypes = { 'nix' },
			settings = {
				nixd = {
					nixpkgs = {
						-- nixd requires some configuration in flake based configs.
						-- luckily, the nixCats plugin is here to pass whatever we need!
						expr = [[import (builtins.getFlake "]] .. nixCats.extra('nixdExtras.nixpkgs') .. [[") { }   ]],
					},
					formatting = {
						command = { 'nixfmt' },
					},
				},
			},
		},
	},
	{
		'rust_analyzer',
		for_cat = 'rust',
		lsp = {
			filetypes = { 'rust' },
			settings = { ['rust-analyzer'] = { check = { command = 'clippy' } } },
		},
	},
	{
		'csharp_ls',
		for_cat = 'csharp',
		lsp = {
			filetypes = { 'cs' },
			cmd_env = {
				DOTNET_ROOT = nixCats.extra['dotnet-sdk'].sdk_9 .. '/share/dotnet',
				DOTNET_MULTILEVEL_LOOKUP = 0,
				PATH = nixCats.extra['dotnet-sdk'].sdk_9 .. '/bin' .. vim.env.PATH,
			},
		},
	},
	{
		'bashls',
		for_cat = 'bash',
		lsp = {
			filetypes = { 'bash', 'sh' },
		},
	},
})
