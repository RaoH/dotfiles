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
	{ "<leader>f",  group = "file" }, -- group
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

	{ "<leader>b",  group = "Buffers" },
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

	{ "<leader>c",  group = "code" },
	{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code action " },
	{ "<leader>cr", ":IncRename ",           desc = "IncRename" },
	{ "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Symbols Outline" },
	{ "<leader>cm", "<cmd>Mason<cr>",        desc = "Mason" },
	{ "<leader>cl", "<cmd>LspRestart<cr>",   desc = "LspRestart" },
	{
		"<leader>cc",
		function()
			require("refactoring").select_refactor({})
		end,
		desc = "Select refactoring",
	},
	-- Conform
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
	{ "<leader>cp",  group = "Copilot" },
	{ "<leader>cpo", "<cmd>:CopilotChatOpen<cr>",    desc = "Copilot Chat " },
	{ "<leader>cpt", "<cmd>:CopilotChatToggle<cr>",  desc = "Copilot Chat toggle " },
	{ "<leader>cpr", "<cmd>:CopilotChatReview<cr>",  desc = "Copilot Chat Review " },
	{ "<leader>cpe", "<cmd>:CopilotChatExplain<cr>", desc = "Copilot Chat Explain " },
	{ "<leader>cpf", "<cmd>:CopilotChatFix<cr>",     desc = "Copilot Chat Fix " },
	{ "<leader>cpc", "<cmd>:CopilotChatCommit<cr>",  desc = "Copilot Chat Commit " },
	{ "<leader>cpq", "<cmd>:CopilotChatReset<cr>",   desc = "Copilot Chat Commit " },

	{ "<leader>g",   group = "git" },
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
	{ "<leader>x",  group = "Trouble" },
	{
		"<leader>xd",
		"<cmd>Trouble diagnostics<cr>",
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
	{ "<leader>t",  group = "Terminal" },
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
	{ "<leader>p",  group = "Project" },
	{ "<leader>pt", group = "Todo" },
	{
		"<leader>ptt",
		function()
			Snacks.picker.todo_comments()
		end,
		desc = "Find todos",
	},
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
		{ "gd", vim.lsp.buf.definition,                    hidden = true },
		{ "K",  vim.lsp.buf.hover({ border = 'rounded' }), hidden = true },
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
	{ "<leader>k", group = "Kulala" },
	{
		"<leader>kb",
		function()
			require("kulala").scratchpad()
		end,
		desc = "Open scratchpad",
	},
	{
		"<leader>ko",
		function()
			require("kulala").open()
		end,
		desc = "Open kulala",
	},
	{
		"<leader>kc",
		function()
			require("kulala").close()
		end,
		desc = "close kulala",
	},
	{
		"<leader>ks",
		function()
			require("kulala").run()
		end,
		desc = "Run query",
		mode = { "n", "v" },
	},
	-- {'<leader>ku', group = 'Kulala UI'},
	{
		"<leader>kH",
		function()
			require("kulala.ui").show_headers()
		end,
		desc = "Show headers",
	},
	{
		"<leader>kB",
		function()
			require("kulala.ui").show_body()
		end,
		desc = "Show body",
	},
	{
		"<leader>kA",
		function()
			require("kulala.ui").show_headers_body()
		end,
		desc = "Show body and headers",
	},
	{
		"<leader>kV",
		function()
			require("kulala.ui").show_headers_body()
		end,
		desc = "Show verbose",
	},
}

return M
