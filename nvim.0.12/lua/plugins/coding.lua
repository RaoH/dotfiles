vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim.git" }, --dep
	{ src = "https://github.com/smjonas/inc-rename.nvim.git" },
	{ src = "https://github.com/ThePrimeagen/refactoring.nvim.git" },
	{ src = "https://github.com/folke/todo-comments.nvim.git" },
})

require("inc_rename").setup()
require("refactoring").setup()
require("todo-comments").setup({
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
	--
	highlight = {
		pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
	},
	search = {
		command = "rg",
		args = {
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
		},
		-- regex that will be used to match keywords.
		-- don't replace the (KEYWORDS) placeholder
		-- pattern = [[\b(KEYWORDS):]], -- ripgrep regex
		pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
	},
})
