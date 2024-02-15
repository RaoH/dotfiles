return {
	{
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup()
			local wk = require("which-key")

			wk.register({
				c = {
					s = { ":IncRename ", "IncRename" },
				},
			}, { prefix = "<leader>" })
		end,
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("refactoring").setup()

			vim.keymap.set({ "n", "x" }, "<leader>rr", function()
				require("refactoring").select_refactor()
			end)
		end,
	},
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		config = true,
	},
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		config = true,
	},
}
