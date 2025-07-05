local servers = {}
servers.csharp_ls = {
	cmd_env = {
		DOTNET_ROOT = nixCats.extra["dotnet-sdk"].sdk_9 .. "/share/dotnet";
		DOTNET_MULTILEVEL_LOOKUP = "0";
		PATH = nixCats.extra["dotnet-sdk"].sdk_9 .. "/bin" .. vim.env.PATH;
	}
}
servers.lua_ls = {
	Lua = {
		formatters = {
			ignoreComments = true,
		},
		signatureHelp = { enabled = true },
		diagnostics = {
			globals = { 'nixCats' },
			disable = { 'missing-fields' },
		},
	},
	telemetry = { enabled = false },
	filetypes = { 'lua' },
}
servers.nixd = {
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
}
servers.rust_analyzer = {}

require('lze').load({
	{
		'nvim-lspconfig',
		for_cat = 'general.lsp',
		event = 'DeferredUIEnter',
		after = function(plugin)
			for server_name, cfg in pairs(servers) do
				require('lspconfig')[server_name].setup({
					capabilities = require('config.lsp.configure').capabilities(server_name),
					on_attach = require('config.lsp.configure').on_attach,
					settings = cfg,
					filetypes = (cfg or {}).filetypes,
					cmd = (cfg or {}).cmd,
					root_pattern = (cfg or {}).root_pattern,
				})
			end
		end,
	},
})
