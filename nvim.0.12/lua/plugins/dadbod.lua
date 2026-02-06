vim.pack.add({
	{ src = "https://github.com/tpope/vim-dadbod" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-ui" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-completion" },
})

-- UI Configuration
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1

-- Keybindings via which-key
local wk = require("which-key")
wk.add({
	{ "<leader>D", group = "database" },
	{ "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle DB UI" },
	{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find buffer" },
	{ "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename buffer" },
	{ "<leader>Dl", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
})

-- UI Configuration
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1

-- Helper: Open floating SQL buffer connected to DBUI
local function open_sql_float()
	-- Create a temp .sql file
	local tmpfile = vim.fn.tempname() .. ".sql"

	-- Open in float via Snacks
	local win = Snacks.win({
		file = tmpfile,
		width = 0.8,
		height = 0.8,
		border = "rounded",
		backdrop = 60,
		title = " SQL Query ",
		title_pos = "center",
		ft = "sql",
		bo = {
			modifiable = true,
			buftype = "",
		},
	})

	-- After opening, link buffer to a DBUI connection
	-- This prompts user to pick a connection if not already set
	vim.schedule(function()
		vim.cmd("DBUIFindBuffer")
	end)
end

-- Keybindings via which-key
local wk = require("which-key")
wk.add({
	{ "<leader>D", group = "database" },
	{ "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle DB UI" },
	{
		"<leader>Ds",
		open_sql_float,
		desc = "SQL scratch (float)",
	},
	{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find buffer" },
	{ "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename buffer" },
	{ "<leader>Dl", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
})
