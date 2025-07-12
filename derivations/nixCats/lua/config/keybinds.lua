-- Basic keymaps
vim.keymap.set({ 'n', 'v', 'x' }, '<C-a>', 'gg0vG$', { noremap = true, silent = true, desc = 'Select all' })

-- Buffer navigation
vim.keymap.set('n', '<leader>b[', '<cmd>bprev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>b]', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bl', '<cmd>b#<CR>', { desc = 'Last buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'delete buffer' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = 'Go to next diagnostic message' })
-- kinda redundant now since virtual lines do the same thing
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- diagnostics
vim.keymap.set('n', '<leader>ea', function()
	vim.diagnostic.config(vim.tbl_deep_extend('force', vim.diagnostic.config(), { virtual_lines = true }))
end, { desc = '[A]ll Diagnostics' })
vim.keymap.set('n', '<leader>ec', function()
	vim.diagnostic.config(
		vim.tbl_deep_extend('force', vim.diagnostic.config(), { virtual_lines = { current_line = true } })
	)
end, { desc = '[C]urrent Diagnostics' })
vim.keymap.set('n', '<leader>en', function()
	vim.diagnostic.config(vim.tbl_deep_extend('force', vim.diagnostic.config(), { virtual_lines = false }))
end, { desc = '[N]o Diagnostics' })

-- Yank to clipboard
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
vim.keymap.set(
	{ 'n', 'v', 'x' },
	'<leader>Y',
	'"+yy',
	{ noremap = true, silent = true, desc = 'Yank line to clipboard' }
)

-- Paste from clipboard
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>p', '"+p', { noremap = true, silent = true, desc = 'Paste from clipboard' })
vim.keymap.set(
	'i',
	'<C-p>',
	'<C-r><C-p>+',
	{ noremap = true, silent = true, desc = 'Paste from clipboard from within insert mode' }
)
vim.keymap.set(
	'x',
	'<leader>P',
	'"_dP',
	{ noremap = true, silent = true, desc = 'Paste over selection without erasing unnamed register' }
)

-- LSP
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP: [C]ode [A]ction' })
vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'LSP: Type [D]efinition' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP: [R]e[n]ame' })
vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'LSP: [W]orkspace [A]dd Folder' })
vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'LSP: [W]orkspace [R]emove Folder' })
vim.keymap.set('n', '<leader>wl', function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = 'LSP: [W]orkspace [L]ist Folders' })
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'LSP: Signature Documentation' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP: [G]oto [D]eclaration' })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP: [G]oto [D]efinition' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP: Hover Documentation' })
