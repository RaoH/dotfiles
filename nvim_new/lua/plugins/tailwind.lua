return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				tailwindcss = {
					-- exclude a filetype from the default_config
					filetypes_exclude = { "markdown" },
					-- add additional filetypes to the default_config
					filetypes_include = {},
					-- to fully override the default_config, change the below
					-- filetypes = {}
				},
			},
			setup = {
				tailwindcss = function(_, opts)
					local tw = require("lspconfig.server_configurations.tailwindcss")
					opts.filetypes = opts.filetypes or {}

					-- Add default filetypes
					vim.list_extend(opts.filetypes, tw.default_config.filetypes)

					-- Remove excluded filetypes
					--- @param ft string
					opts.filetypes = vim.tbl_filter(function(ft)
						return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
					end, opts.filetypes)

					-- Add additional filetypes
					vim.list_extend(opts.filetypes, opts.filetypes_include or {})
				end,
			},
		},
	},
	{
		"NvChad/nvim-colorizer.lua",
		enabled = false,
		config = function()
			require("colorizer").setup({
				user_default_options = {
					tailwind = true,
				},
			})
		end,
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		-- optionally, override the default options:
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})
		end,
	},
}
