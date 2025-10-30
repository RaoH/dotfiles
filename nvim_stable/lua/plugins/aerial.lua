return {
	{
		"stevearc/aerial.nvim",
		enabled = false,
		opts = {},
		-- Optional dependencies
		config = function()
			require("aerial").setup({
				backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
}
