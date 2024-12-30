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

			telescope.setup({
				pickers = {
					find_files = {
					}
				},
				extensions = {
					fzf = {},
					aerial = {
						-- Set the width of the first two columns (the second
						-- is relevant only when show_columns is set to 'both')
						col1_width = 4,
						col2_width = 30,
						-- How to format the symbols
						format_symbol = function(symbol_path, filetype)
							if filetype == "json" or filetype == "yaml" then
								return table.concat(symbol_path, ".")
							else
								return symbol_path[#symbol_path]
							end
						end,
						-- Available modes: symbols, lines, both
						show_columns = "both",
					},
				}

			})

			telescope.load_extension("fzf")
			telescope.load_extension("toggleterm")
			telescope.load_extension("aerial")
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
