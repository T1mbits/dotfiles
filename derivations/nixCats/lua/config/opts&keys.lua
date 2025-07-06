-- Set mapleader. Must be set before loading plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Display whitespace characters
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Hide default mode and search count indicator (lualine provides the indicators)
vim.o.showmode = false
vim.o.shortmess = vim.o.shortmess .. 'S'

-- Highlight on search, turn off highlight with esc
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Preview substitutions as you type
vim.opt.inccommand = 'split'

-- Minimum amount of lines above/below cursor
vim.opt.scrolloff = 10

-- Line numbers by default
vim.wo.number = true

-- Indenting
vim.o.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Save undo history
vim.o.undofile = true

-- Case-insensitive search unless \C or capitals in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable signcolumn and relative line numbers by default
-- x amount of signcolumn slots simultaneously
vim.wo.signcolumn = 'yes:2'
vim.wo.relativenumber = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Completion menu
vim.o.completeopt = 'menu,preview,noselect'

-- Enable 24-bit colour support
vim.o.termguicolors = true

-- Disable virtual text diagnostics message in favour of hover diagnostics
vim.diagnostic.config({ virtual_text = false })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.hl.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

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
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

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
