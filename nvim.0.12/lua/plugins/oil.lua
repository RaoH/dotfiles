vim.pack.add({'https://github.com/stevearc/oil.nvim'})

require("oil").setup({
	view_options = {
		-- Show files and directories that start with "."
		show_hidden = false,
	}
})

