return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-smart-history.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = 'make' },
		},
		config = function()
			local telescope = require("telescope")

			telescope.load_extension("fzf")
			telescope.load_extension("toggleterm")
		end,
	},
	{
		"nvim-telescope/telescope-frecency.nvim",
		enabled = false,
		config = function()
			require("telescope").load_extension("frecency")
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
