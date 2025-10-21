vim.pack.add({ "https://github.com/folke/which-key.nvim.git" })

local is_dimmed = false
local opencode = require("opencode")

local wk = require("which-key")
wk.add({
	{
		"<leader>!",
		function()
			Snacks.dashboard.open()
		end,
		desc = "Open dashboard",
	},
	{ "<leader>f", group = "Project" }, -- group
	{
		"<leader>/",
		function()
			Snacks.picker.grep()
		end,
		hidden = true,
		remap = true,
	},
	{
		"<leader>fg",
		function()
			Snacks.picker.git_files({ hidden = true })
		end,
		desc = "Find files",
	},
	{
		"<leader>ff",
		function()
			Snacks.picker.files({ hidden = true })
		end,
		desc = "Find Git File",
	},
	{
		"<leader>fo",
		function()
			Snacks.picker.recent()
		end,
		desc = "Open Recent File",
	},
	{
		"<leader>fd",
		function()
			Snacks.picker.diagnostics()
		end,
		desc = "Open Project Diagnostics",
	},
	{
		"<leader>ft",
		function()
			Snacks.picker.todo_comments()
		end,
		desc = "Find todos",
	},
	{
		"<leader>fr",
		function()
			Snacks.picker.resume()
		end,
		desc = "Resume search",
	},
	{
		"<leader>fh",
		function()
			Snacks.picker.help()
		end,
		desc = "Open Help Tags",
	},
	{ "<leader>fe", "<cmd>Oil<cr>", desc = "Oil" },
	{
		"<leader>u",
		function()
			Snacks.picker.help()
		end,
		desc = "Undo picker",
	},
	-- Buffers
	{ "<leader>b", group = "Buffers" },
	{
		"<leader>bl",
		function()
			Snacks.picker.buffers()
		end,
		desc = "Find buffers",
	},
	{
		"<leader>bg",
		function()
			Snacks.picker.grep_buffers()
		end,
		desc = "Find buffers",
	},
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

	--code
	{ "<leader>c", group = "code" },
	{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code action " },
	{ "<leader>cr", ":IncRename ", desc = "IncRename" },
	{ "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
	-- { "<leader>cl", "<cmd>LspRestart<cr>", desc = "LspRestart" },
	{
		"<leader>cc",
		function()
			require("refactoring").select_refactor({})
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
	{ "<leader>co", group = "Opencode" },
	{
		"<leader>coa",
		mode = { "n", "x" },
		function()
			print("test")
			opencode.ask("@this: ", { submit = true })
		end,
		desc = "Ask about this",
	},
	{
		"<leader>cos",
		mode = { "n", "x" },
		function()
			opencode.select()
		end,
		desc = "Select prompt",
	},
	{
		"<leader>co+",
		mode = { "n", "x" },
		function()
			opencode.prompt("@this")
		end,
		desc = "Add this",
	},
	{
		"<leader>cot",
		mode = { "n" },
		function()
			opencode.toggle()
		end,
		desc = "Toggle embedded",
	},
	{
		"<leader>coc",
		mode = { "n" },
		function()
			opencode.command()
		end,
		desc = "Select command",
	},
	{
		"<leader>com",
		mode = { "n" },
		function()
			local commitmsg = require("opencode.config").opts.prompts.commitmsg
			opencode.prompt(commitmsg.prompt, commitmsg)
		end,
		desc = "New session",
	},
	{
		"<leader>cob",
		mode = { "n" },
		function()
			local commitmsg = require("opencode.config").opts.prompts.createbranchfromdiff
			opencode.prompt(commitmsg.prompt, commitmsg)
		end,
		desc = "New session",
	},
	{
		"<leader>con",
		mode = { "n" },
		function()
			opencode.command("session_new")
		end,
		desc = "New session",
	},
	{
		"<leader>coi",
		mode = { "n" },
		function()
			opencode.command("session_interrupt")
		end,
		desc = "Interrupt session",
	},
	{
		"<leader>coA",
		mode = { "n" },
		function()
			opencode.command("agent_cycle")
		end,
		desc = "Cycle selected agent",
	},
	{
		"<S-C-u>",
		mode = { "n" },
		function()
			opencode.command("messages_half_page_up")
		end,
		desc = "Messages half page up",
	},
	{
		"<S-C-d>",
		mode = { "n" },
		function()
			opencode.command("messages_half_page_down")
		end,
		desc = "Messages half page down",
	},

	-- -- Copilot
	-- { "<leader>cp", group = "Copilot" },
	-- { "<leader>cpo", mode = { "n", "v" }, "<cmd>:CopilotChatOpen<cr>", desc = "Copilot Chat" },
	-- { "<leader>cpt", mode = { "n", "v" }, "<cmd>:CopilotChatToggle<cr>", desc = "Copilot Chat toggle" },
	-- { "<leader>cpr", mode = { "n", "v" }, "<cmd>:CopilotChatReview<cr>", desc = "Copilot Chat Review" },
	-- { "<leader>cpe", mode = { "n", "v" }, "<cmd>:CopilotChatExplain<cr>", desc = "Copilot Chat Explain" },
	-- { "<leader>cpf", mode = { "n", "v" }, "<cmd>:CopilotChatFix<cr>", desc = "Copilot Chat Fix" },
	-- { "<leader>cpc", "<cmd>:CopilotChatCommit<cr>", desc = "Copilot Chat Commit" },
	-- { "<leader>cpq", "<cmd>:CopilotChatReset<cr>", desc = "Copilot Reset" },

	{ "<leader>g", group = "git" },
	{
		"<leader>gb",
		function()
			Snacks.git.blame_line()
		end,
		desc = "Git Blame Line",
	},
	{
		"<leader>gc",
		function()
			Snacks.picker.git_log()
		end,
		desc = "Git commits",
	},
	{
		"<leader>g!",
		function()
			Snacks.picker.git_status()
		end,
		desc = "Git status",
	},
	{
		"<leader>gl",
		function()
			Snacks.lazygit()
		end,
		desc = "lazygit",
	},
	{
		"<c-\\>",
		mode = { "n", "t" },
		function()
			Snacks.terminal(nil, {
				win = {
					style = {
						border = "rounded",
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
	-- Project
	{ "<leader>p", group = "Project" },
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
		{ "K", vim.lsp.buf.hover({ border = "rounded" }), hidden = true },
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

	{ "<leader>n", group = "Notifications" },
	{
		"<leader>nh",
		function()
			Snacks.notifier.show_history()
		end,
		desc = "Notification History",
	},
	{
		"<leader>nd",
		function()
			Snacks.notifier.hide()
		end,
		desc = "Dismiss All Notifications",
	},
})
