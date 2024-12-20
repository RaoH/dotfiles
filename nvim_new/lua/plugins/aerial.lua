return {
	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		config = function()
			require("aerial").setup()
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
}
