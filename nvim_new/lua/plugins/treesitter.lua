return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-telescope/telescope-file-browser.nvim",
	},
	build = ":TSUpdate",
	config = function()
		local treesitter_conf = require("nvim-treesitter.configs")

		treesitter_conf.setup({
			ensure_installed = { "lua", "elixir", "javascript", "html" },
			highlight = { enable = true },
			indent = { enable = true },
			autotag = true,
		})
	end,
}
