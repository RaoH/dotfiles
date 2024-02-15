return {
	{
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
			local ensure_install_list = {
				"astro",
				"bash",
				"cmake",
				"cpp",
				"css",
				"elixir",
				"fish",
				"gitignore",
				"go",
				"graphql",
				"html",
				"html",
				"http",
				"java",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"php",
				"python",
				"query",
				"regex",
				"rust",
				"scss",
				"sql",
				"svelte",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			}

			treesitter_conf.setup({
				ensure_installed = ensure_install_list,
				highlight = { enable = true },
				indent = { enable = true },
				autotag = true,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = { mode = "cursor", max_lines = 3 },
	},
}
