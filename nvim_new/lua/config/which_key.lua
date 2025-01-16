local M = {}

local is_dimmed = false

local function get_current_dir()
	local current_dir = vim.fn.expand("%:p:h")
	if current_dir == "" or vim.fn.isdirectory(current_dir) == 0 then
		current_dir = vim.fn.getcwd()
	end
	return current_dir
end

local function open_named_terminal(cmd)
	local current_dir = get_current_dir()
	Snacks.terminal(cmd, {
		cwd = current_dir,
		win = {
			style = {
				border = "rounded",
			},
		},
	})
end

M.keymap = {
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
	{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Open Help Tags" },
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
	{ "<leader>cs", "<cmd>Telescope aerial<cr>", desc = "Symbols Outline" },
	{ "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
	{ "<leader>cl", "<cmd>LspRestart<cr>", desc = "LspRestart" },
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
		"<leader>gc",
		"<cmd>Telescope git_commits",
		desc = "Git commits",
	},
	{
		"<leader>g!",
		"<cmd>Telescope git_status",
		desc = "Git status",
	},
	{
		"<leader>gs",
		"<cmd>Telescope git_stash",
		desc = "Git stash",
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
	{
		"<leader>tp",
		function()
			open_named_terminal("cbonsai")
		end,
		desc = "Terminal bottom",
	},
	{
		"<leader>tt",
		group = "Turborepo",
	},
	{
		"<leader>ttb",
		function()
			open_named_terminal("turbo build")
		end,
		desc = "Turbo",
	},
	{
		"<leader>ttt",
		function()
			open_named_terminal("turbo test")
		end,
		desc = "Turbo test",
	},
	{
		"<leader>ttp",
		function()
			open_named_terminal("turbo playwright:run")
		end,
		desc = "Turbo playwright",
	},
	{
		"<leader>ttw",
		function()
			open_named_terminal("turbo run dev:ssl --filter kollarna-wizard")
		end,
		desc = "Turbo run kollarna-wizard",
	},
	{
		"<leader>tta",
		function()
			open_named_terminal("turbo run dev:ssl --filter kollarna-patient-portal")
		end,
		desc = "Turbo run kollarna-patient-portal",
	},

	-- {
	-- 	"<leader>ttr",
	-- 	function()
	-- 		Snacks.input(
	-- 			{
	-- 				prompt: "Which app should be loaded"
	-- 				completion:
	-- 			}
	-- 		)
	-- 		open_named_terminal("turbo build")
	-- 	end,
	-- 	desc = "Turbo"
	-- },

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
}

return M
