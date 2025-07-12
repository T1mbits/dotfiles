-- Set mapleader. Must be set before loading plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Display whitespace characters
vim.opt.list = true
vim.opt.listchars = {
	tab = '▎ ', --[[ eol = '↵', ]]
	trail = '·',
	nbsp = '␣',
}

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
vim.wo.signcolumn = 'yes:1'
vim.wo.relativenumber = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Completion menu
vim.o.completeopt = 'menu,preview,noselect'

-- Enable 24-bit colour support
vim.o.termguicolors = true

-- Use virtual line diagnostics instead of virtal text
vim.diagnostic.config({ signs = false, virtual_text = false, virtual_lines = true })
