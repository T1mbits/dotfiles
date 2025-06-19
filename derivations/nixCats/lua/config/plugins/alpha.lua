local function dashboard_config()
	local dashboard = require('alpha.themes.dashboard')
	local splash_texts = {
		"you're not supposed to be coding right now are you?",
		"go to bed",
		"ketchup is a smoothie",
		"miscellaneous splash text brought to you by Timbits",
		[["I turned off my screen time trackers because they made me sad"]],
		"I wonder if this config is even complete",
		"Go finish your current project before you start another one"
	}
	local ascii_image = {
		"                ██████    ██████",
		"                ██  ██    ██  ██",
		"                ██  ████████  ██",
		"              ████            ██",
		"            ████    ██    ██  ██",
		"      ████████                ██",
		"  ██████              ██      ██",
		"████                          ██",
		"██                            ██",
		"████                        ████",
		"  ████████████████████████████",
		"",
		"       hi-kwality scugvim",
	}

	local win_height = vim.api.nvim_win_get_height(0)

	-- first num is length of ascii_image, second is dashboard.section.buttons.val length * 2, the -3 is the space already present from the theme (never changes using dashboard theme as a base)
	local padding_count = (win_height - 12 - 8 - 3) / 2

	for _ = 1, padding_count, 1 do
		table.insert(ascii_image, 1, "")
	end

	dashboard.section.header.val = ascii_image

	dashboard.section.buttons.val = {
		dashboard.button('SPC e', '  New file', '<Cmd>ene<CR>'),
		dashboard.button('SPC s p', '󰥨  Projects'),
		dashboard.button('SPC s f', '󰈞  Find file'),
		dashboard.button('SPC q', '  Quit', '<Cmd>qa<CR>'),
	}

	dashboard.section.footer.val = splash_texts[math.random(#splash_texts)];

	return dashboard.config
end

vim.api.nvim_create_autocmd('VimResized', {
	group = vim.api.nvim_create_augroup('AlphaResizePadding', { clear = true }),
	callback = function()
		require('alpha').setup(dashboard_config())
	end,
})

return {
	{
		'alpha-nvim',
		on_cat = 'general.ui',
		after = function(plugin)
			require('alpha').setup(dashboard_config())
			-- I still don't know how to use VIM why is notchoc judging me I'm scared for my safety
		end,
	},
}
