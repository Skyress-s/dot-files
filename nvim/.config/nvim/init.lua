-- <CTRL-w>d shows diagnostic

vim.o.number = true
vim.o.scrolloff = 8
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.termguicolors = true
vim.o.wrap = false

vim.o.tabstop = 8
vim.o.shiftwidth = 8
vim.o.expandtab = false

vim.o.swapfile = false
vim.g.mapleader = ' '
vim.o.winborder = 'rounded'
vim.o.clipboard = 'unnamedplus'

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>W', ':wa<CR>')
-- vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', 'dw', 'diw')
--vim.keymap.set('i', '<C-H>', '<C-W>', { noremap = true }) -- How the fu*& is C-H Ctrl + Backspace?!?!? This work as ctrl + backspace in normal text editor
vim.keymap.set('i', '<C-H>', '<C-W>', { noremap = true })  -- How the fu*& is C-H Ctrl + Backspace?!?!? This work as ctrl + backspace in normal text editor
vim.keymap.set('i', '<C-BS>', '<C-W>', { noremap = true }) -- How the fu*& is C-H Ctrl + Backspace?!?!? This work as ctrl + backspace in normal text editor
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')
vim.keymap.set('n', '<leader><F9>', ':term odin run src/<CR>')
-- vim.keymap.set('n', 'nn', 'vim.diagnostic.open_float()')
--
vim.api.nvim_set_keymap('n', 'd', '"dd', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'dd', '"ddd', {noremap = true, silent = true})
--
vim.keymap.set('n', '<leader>vr', ':Pick visit_paths<CR>')
vim.keymap.set('n', '<leader>vl', ':Pick visit_labels<CR>')
vim.keymap.set('n', '<leader>va', ':lua MiniVisits.add_label()<CR>')
vim.keymap.set('n', '<leader>vd', ':lua MiniVisits.remove_label()<CR>')

vim.keymap.set('n', '<leader>sr', ':lua MiniSessions.select("read")<CR>')
vim.keymap.set('n', '<leader>sa', function()
	vim.ui.input({ prompt = "Session Name: " }, function(input)
		vim.cmd('lua MiniSessions.write("' .. input .. '")')
	end
	)
end
)


vim.pack.add {
	-- { src = "https://github.com/vague2k/vague.nvim" },
	{ src = 'https://github.com/folke/tokyonight.nvim' },
	-- { src = "https://github.com/catppuccin/nvim" },
	{ src = 'https://github.com/folke/which-key.nvim' },
	{ src = 'https://github.com/rebelot/kanagawa.nvim' },
	{ src = 'https://github.com/stevearc/oil.nvim' },
	{ src = 'https://github.com/echasnovski/mini.pick' },
	{ src = 'https://github.com/echasnovski/mini.extra' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/chomosuke/typst-preview.nvim' },
	{ src = 'https://github.com/mason-org/mason.nvim' },
	{ src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
	{ src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
	{ src = 'https://github.com/Saghen/blink.cmp' },
	{ src = 'https://github.com/ggandor/leap.nvim' },
	{ src = 'https://github.com/nvim-lualine/lualine.nvim' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
	{ src = 'https://github.com/nvim-mini/mini.sessions' },
	{ src = 'https://github.com/nvim-mini/mini.visits' },
	{ src = 'https://github.com/lewis6991/gitsigns.nvim' },
}
require('gitsigns').setup()
require('mini.sessions').setup({})
require('mini.visits').setup({
	list = {

	}
})
local win_config = function()
	local height = math.floor(0.618 * vim.o.lines)
	local width = math.floor(0.618 * vim.o.columns)
	return {
		anchor = 'NW',
		height = height,
		width = width,
		row = math.floor(0.5 * (vim.o.lines - height)),
		col = math.floor(1.0 * (vim.o.columns - width)),
		-- col = 0
	}
end
require('mini.pick').setup({
	window = {
		config = win_config()
	}

})

-- Override nvim normal ui.select function to use Mini.Pick's ui_select instead!
-- This means that other plugins that uses vim.ui.select will now appear here instead
vim.ui.select = MiniPick.ui_select
-- Customize with fourth argument inside a function wrapper
vim.ui.select = function(items, opts, on_choice)
	local start_opts = { window = { config = { width = vim.o.columns } } }
	return MiniPick.ui_select(items, opts, on_choice, start_opts)
end

vim.diagnostic.config({
	update_in_insert = true,

})
-- Autocommand to trigger diagnostics update on text change
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
	callback = function()
		vim.diagnostic.setloclist({ open = false }) -- optional: update loclist without opening
	end,
})

require('treesitter-context').setup {}

require('which-key').setup {
}

require('lualine').setup {}

require('mini.extra').setup {}

require('leap').set_default_mappings() -- Super based

require('blink.cmp').setup {
	-- fuzzy = { implementation = "prefer_rust_with_warning" },
	fuzzy = { implementation = 'lua' }, -- This should probably use rust instead. But lua is easier to compile. Will probably be slightly slower, but works fine for now!
	-- build = 'cargo build --release',
	signature = { enabled = true }, -- TODO: Why is this not working currently?
	-- version = '1.*'
}

require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup {
	ensure_installed = {
		'lua_ls',
		'stylua',
		'ols',
	},
}

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = {
					'vim',
					'require',
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file('', true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

--
--vim.api.nvim_create_autocmd('LspAttach', {
-- callback = function(ev)
-- local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- if client:supports_method('textDocument/completion') then
-- vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
-- end
-- end,
--})
--vim.cmd("set completeopt+=noselect")

require('nvim-treesitter.configs').setup {
	ensure_installed = { 'diff', 'svelte', 'typescript', 'javascript', 'odin', 'cpp' },
	highlight = { enable = true },
}

require('oil').setup()

vim.keymap.set('n', '<leader>sf', ":Pick buf_lines scope='current'<CR>")
vim.keymap.set('n', '<leader>sF', ":Pick grep_live pattern=''<CR>")
-- vim.keymap.set('n', '<leader>sF', ":Pick buf_lines scope='all'<CR>")
vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>h', ':Pick help<CR>')
vim.keymap.set('n', '<leader>Q', ":Pick diagnostic scope='all'<CR>")
vim.keymap.set('n', '<leader>q', ":Pick diagnostic scope='current'<CR>")

vim.keymap.set('n', '<leader>e', ':Oil<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
--vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition)
vim.keymap.set('n', 'grd', vim.lsp.buf.definition)

vim.lsp.enable { 'lua_ls', 'biome', 'tinymist', 'emmetls', 'ols', 'clangd' }

vim.lsp.config('ols', {
	init_options = {
		enable_references = true,
	},
})

-- require "vague".setup({ transparent = true })
-- vim.cmd("colorscheme vague")
-- vim.cmd(":hi statusline guibg=NONE")

--require "catppuccin".setup({})
--vim.cmd("colorscheme catppuccin-mocha")

require "tokyonight".setup({})
vim.cmd("colorscheme tokyonight-night") -- night moon storm day

-- require('kanagawa').setup {}
-- vim.cmd 'colorscheme kanagawa-wave' -- wave, dragon, lotus
