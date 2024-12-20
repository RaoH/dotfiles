local is_dimmed = false

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")
		wk.add({
			{
				"<leader>!",
				function()
					Snacks.dashboard.open()
				end,
				desc = "Open dashboard",
			},
			{ "<leader>f", group = "file" }, -- group
			-- Telescope
			{ "<leader>/", "<cmd>Telescope live_grep<cr>", hidden = true, remap = true },
			{ "<leader>fd", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>ff", "<cmd>Telescope git_files<cr>", desc = "Find Git File" },
			{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Open Recent File" },
			{ "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Resume previous telescope search" },
			{ "<leader>ft", "<cmd>Telescope builtin<cr>", desc = "Telescope builtin" },
			---
			{ "<leader>fe", "<cmd>Oil<cr>", desc = "Oil" },

			{ "<leader>b", group = "Buffers" },
			{ "<leader>bl", "<cmd>Telescope buffers <cr>", desc = "Find buffers" },
			{
				"<leader>bD",
				function()
					Snacks.bufdelete.all({ force = true })
				end,
				desc = "Delete All Buffer (Force)",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},

			{
				"<leader>bo",
				function()
					Snacks.bufdelete.other({ force = true })
				end,
				desc = "Delete other buffers",
			},

			{
				"<leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},

			{ "<leader>c", group = "code" },
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code action " },
			{ "<leader>cr", ":IncRename ", desc = "IncRename" },
			{ "<leader>cs", "<cmd>:AerialToggle<cr>", desc = "Symbols Outline" },
			{ "<leader>cm", "<cmd>:Mason<cr>", desc = "Mason" },
			{
				"<leader>cc",
				function()
					require("refactoring").select_refactor()
				end,
				desc = "Select refactoring",
			},
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
					desc = "Format file or range (in visual mode)",
				},
			},

			-- Copilot
			{ "<leader>cp", group = "Copilot" },
			{ "<leader>cpo", "<cmd>:CopilotChatOpen<cr>", desc = "Copilot Chat " },
			{ "<leader>cpt", "<cmd>:CopilotChatToggle<cr>", desc = "Copilot Chat toggle " },
			{ "<leader>cpr", "<cmd>:CopilotChatReview<cr>", desc = "Copilot Chat Review " },
			{ "<leader>cpe", "<cmd>:CopilotChatExplain<cr>", desc = "Copilot Chat Explain " },
			{ "<leader>cpf", "<cmd>:CopilotChatFix<cr>", desc = "Copilot Chat Fix " },
			{ "<leader>cpc", "<cmd>:CopilotChatCommit<cr>", desc = "Copilot Chat Commit " },
			{ "<leader>cpq", "<cmd>:CopilotChatReset<cr>", desc = "Copilot Chat Commit " },
			-- Conform

			{ "<leader>g", group = "git" },
			{
				"<leader>gb",
				function()
					Snacks.git.blame_line()
				end,
				desc = "Git Blame Line",
			},
			{
				"<leader>gl",
				function()
					Snacks.lazygit()
				end,
				desc = "lazygit",
			},

			{ "<leader>x", group = "Trouble" },
			{
				"<leader>xd",
				"<cmd>TroubleToggle document_diagnostics<cr>",
				desc = "Open trouble document diagnostics",
			},
			{
				"<leader>xl",
				"<cmd>TroubleToggle loclist<cr>",
				desc = "Open trouble location list",
			},
			{
				"<leader>xq",
				"<cmd>TroubleToggle quickfix<cr>",
				desc = "Open trouble quickfix list",
			},
			{ "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Open todos in trouble" },
			{
				"<leader>xw",
				"<cmd>TroubleToggle workspace_diagnostics<cr>",
				desc = "Open trouble workspace diagnostics",
			},
			{
				"<leader>xx",
				"<cmd>TroubleToggle<cr>",
				desc = "Open/Close trouble list",
			},

			-- Terminal stuff
			{ "<leader>t", group = "Terminal" },
			{ "<leader>tn", "<cmd>ToggleTerm direction=float<cr>", desc = "Float" },
			{ "<leader>th", "<cmd>ToggleTerm cmd=htop direction=float name=htop<cr>", desc = "htop" },
			{
				"<leader>tt",
				function()
					Snacks.terminal.toggle(nil, {
						win = {
							style = {
								position = "float",
								backdrop = 60,
								height = 0.9,
								width = 0.9,
								zindex = 50,
							},
						},
					})
				end,
				desc = "Snacks toggle term",
			},
			{
				"<C-/>",
				mode = { "n", "t" },
				function()
					local venv = vim.b["virtual_env"]
					local term = require("toggleterm.terminal").Terminal:new({
						env = venv and { VIRTUAL_ENV = venv } or nil,
						count = vim.v.count > 0 and vim.v.count or 1,
					})
					term:toggle()
				end,
				desc = "htop",
			},

			-- Project
			{ "<leader>p", group = "Project" },
			{ "<leader>pt", group = "Todo" },
			{ "<leader>ptt", "<cmd>TodoTelescope<cr>", desc = "Find todos" },
			-- Editor
			{ "<leader>e", group = "Editor" },
			{
				"<leader>ed",
				function()
					if is_dimmed then
						Snacks.dim.disable()
					else
						is_dimmed = true
						Snacks.dim.enable()
					end
				end,
				desc = "Precognition toggle",
			},
			{
				mode = { "n" },
				{ "gd", vim.lsp.buf.definition, hidden = true },
				{ "K", vim.lsp.buf.hover, hidden = true },
				{
					"<leader>z",
					function()
						Snacks.zen()
					end,
					desc = "Zenmode",
				},
				{
					"zR",
					function()
						require("ufo").openAllFolds()
					end,
				},
				{
					"zM",
					function()
						require("ufo").closeAllFolds()
					end,
				},
			},
			{
				"<leader>n",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},
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
