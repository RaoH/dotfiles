return {

	{
		'akinsho/toggleterm.nvim',
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
				direction = "float"
			})
		end
	},
	{
		'da-moon/telescope-toggleterm.nvim',
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-smart-history.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		config = function()
			require("telescope-toggleterm").setup {
				telescope_mappings = {
					-- <ctrl-c> : kill the terminal buffer (default) .
					["<C-c>"] = require("telescope-toggleterm").actions.exit_terminal,
				},
			}
		end
	}
}
