vim.pack.add({
	{ src = "https://github.com/pwntester/octo.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

require("octo").setup({
	picker = "snacks",
	suppress_missing_scope = {
		projects_v2 = true,
	},
})
