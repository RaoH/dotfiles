return {
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		enabled = false,
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})
		end,
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup({
				user_default_options = {
					mode = "virtualtext",
					tailwind = true,
					virtualtext = "■",
					virtualtext_inline = true,
				},
			})
		end,
		opts = { -- set to setup table
		},
	},
}
