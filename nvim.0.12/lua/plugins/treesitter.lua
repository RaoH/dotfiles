vim.pack.add({

	{ src = "https://github.com/windwp/nvim-ts-autotag.git" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter.git" },
})
--vim.pack.add({"https://github.com/nvim-treesitter/nvim-treesitter-context.git"})

require("nvim-ts-autotag").setup()

local ensure_install_list = {
	"diff",
	"gleam",
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

require("nvim-treesitter.configs").setup({
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
