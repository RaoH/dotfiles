return {
	{
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup()
			local wk = require("which-key")

			wk.register({
				c = {
					r = { ":IncRename ", "IncRename" },
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
		"folke/todo-comments.nvim",
		events = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local opts = {
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
			}

			local wk = require("which-key")
			wk.register({
				c = {
					t = {
						name = "Todo",
						a = { "<cmd>TodoTrouble<cr>", "List project TODOs" },
						t = { "<cmd>TodoTelescop<cr>", "Search project TODOs" },
					},
				},
			})

			require("todo-comments").setup(opts)
		end,
	},
}
