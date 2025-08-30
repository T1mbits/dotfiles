require('config.scripts.eol_marker')
-- disabled temporarily
-- require('config.scripts.diagnostic_sign_column')

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.hl.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})
