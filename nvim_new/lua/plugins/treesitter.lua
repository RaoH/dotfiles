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
				"query",
				"regex",
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
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = { mode = "cursor", max_lines = 3 },
	},
}
