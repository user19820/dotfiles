return {
	'nvim-telescope/telescope.nvim',
	event = 'VimEnter',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
			cond = function ()
				return vim.fn.executable 'make' == 1
			end,
		},
		{
			'nvim-telescope/telescope-ui-select.nvim'
		},
		{ 'nvim-tree/nvim-web-devicons'},
	},
	config = function ()
		require('telescope').setup({
			extensions = {
				['ui-select'] = {
					require('telescope.themes').get_dropdown(),
				},
			},
		})

		pcall(require('telescope').load_extension, 'fzf')
		pcall(require('telescope').load_extension, 'ui-select')

		local builtin = require 'telescope.builtin'
		local map = vim.keymap.set
		
		-- Telescope Keybinds
		map('n', '<leader>fh', builtin.help_tags)
		map('n', '<leader>f', builtin.find_files)
		map('n', '<leader><leader>', builtin.help_tags)
		map('n', '<leader>fd', builtin.diagnostics)
		map('n', '<leader>/', function ()
			builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
				winblend = 10,
				previewer = false,
			})
		end)
	end
}
