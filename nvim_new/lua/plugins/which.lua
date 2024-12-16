return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>f",  group = "file" }, -- group
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File",                       mode = "n" },
			{ "<leader>fn", desc = "New File" },

			{ "<leader>/",  "<cmd>Telescope live_grep<cr>",  hidden = true,                            remap = true },
			{ "<leader>f*", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>ff", "<cmd>Telescope git_files<cr>",  desc = "Find Git File" },
			{ "<leader>fo", "<cmd>Telescope oldfiles<cr>",   desc = "Open Recent File" },
			{ "<leader>fr", "<cmd>Telescope resume<cr>",     desc = "Resume previous telescope search" },
			{ "<leader>fe", "<cmd>Oil<cr>",                  desc = "Oil" },

			{ "<leader>b",  group = "Buffers" },
			{ "<leader>bl", "<cmd>Telescope buffers <cr>",   desc = "Find buffers" },
			{
				"<leader>bD",
				function()
					require("mini.bufremove").delete(0, true)
				end,
				desc = "Delete Buffer (Force)"
			},
			{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },

			{ "<leader>.",  function() Snacks.scratch() end,   desc = "Toggle Scratch Buffer" },

			{ "<leader>c",  group = "code" },
			{ "<leader>ca", vim.lsp.buf.code_action,           desc = "Code action " },
			{ "<leader>cr", "<cmd>:IncRename ",                desc = "IncRename" },
			{ "<leader>cs", "<cmd>:SymbolsOutline<cr>",        desc = "Symbols Outline" },
			{ "<leader>cm", "<cmd>:Mason<cr>",                 desc = "Symbols Outline" },
			{
				mode = { "n", "v" },
				{
					"<leader>cf",
					function()
						require("conform").format({
							lsp_fallback = true,
							async = false,
							timeout_ms = 1000,
						})
					end,
					desc = "Format file or range (in visual mode)"
				},
			},
			{
				"<leader>crr",
				function()
					require("refactoring").select_refactor()
				end,
				desc = "Select refactoring"
			},

			{ "<leader>g",   group = "git" },
			{ "<leader>gb",  function() Snacks.git.blame_line() end,                   desc = "Git Blame Line" },
			{ "<leader>gl",  "<cmd>LazyGit<cr>",                                       desc = "Open Lazygit" },

			-- { "<leader>lg",  "<cmd>LazyGit<cr>",                             desc = "Open Lazygit" },

			{ "<leader>x",   group = "Trouble" },
			{ "<leader>xd",  "<cmd>TroubleToggle document_diagnostics<cr>",            desc = "Open trouble document diagnostics" },
			{ "<leader>xl",  "<cmd>TroubleToggle loclist<cr>",                         desc = "Open trouble location list" },
			{ "<leader>xq",  "<cmd>TroubleToggle quickfix<cr>",                        desc = "Open trouble quickfix list" },
			{ "<leader>xt",  "<cmd>TodoTrouble<cr>",                                   desc = "Open todos in trouble" },
			{ "<leader>xw",  "<cmd>TroubleToggle workspace_diagnostics<cr>",           desc = "Open trouble workspace diagnostics" },
			{ "<leader>xx",  "<cmd>TroubleToggle<cr>",                                 desc = "Open/Close trouble list" },

			-- Terminal stuff
			{ "<leader>t",   group = "Terminal" },
			{ "<leader>tn",  "<cmd>ToggleTerm direction=float<cr>",                    desc = "Float" },
			{ "<leader>th",  "<cmd>ToggleTerm cmd=htop direction=float name=htop<cr>", desc = "htop" },

			{ "<leader>e",   group = "Editor" },
			{ "<leader>ep",  "<cmd>Precognition toggle<cr>",                           desc = "Precognition toggle" },


			{ "<leader>p",   group = "Project" },
			{ "<leader>pt",  group = "Todo" },
			{ "<leader>ptt", "<cmd>TodoTelescope<cr>",                                 desc = "Find todos" },
			{ "cta",         "<cmd>TodoTrouble<cr>",                                   desc = "List project TODOs" },
			{ "ctt",         "<cmd>TodoTelescop<cr>",                                  desc = "Search project TODOs" },
			{
				mode = { "n" },
				{ "gd",        vim.lsp.buf.definition,      hidden = true },
				{ "K",         vim.lsp.buf.hover,           hidden = true },
				{ "<leader>z", function() Snacks.zen() end, desc = 'Zenmode' },
				{ "zR",
					function()
						require("ufo").openAllFolds()
					end
				},
				{ "zM",
					function()
						require("ufo").closeAllFolds()
					end
				},

			},
			{ "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
			{ "<leader>un", function() Snacks.notifier.hide() end,         desc = "Dismiss All Notifications" },
		})
	end,
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
}
