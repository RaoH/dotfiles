vim.pack.add({
	{ src = "https://github.com/tpope/vim-dadbod" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-ui" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-completion" },
})

-- UI Configuration
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_use_nvim_notify = 1

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

local function dbui_toggle()
	-- Check if the drawer is open by looking for a window with filetype "dbui"
	local is_open = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "dbui" then
			is_open = true
			break
		end
	end
	if is_open then
		-- Close DBUI drawer, then wipe all .dbout and DBUI query buffers
		vim.cmd("DBUIClose")
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) then
				local name = vim.api.nvim_buf_get_name(buf)
				local ft = vim.bo[buf].filetype
				local is_dbui_query = vim.b[buf].dbui_db_key_name ~= nil
			if ft == "dbout" or name:match("%.dbout$") or is_dbui_query then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end
		end
	else
		vim.cmd("DBUI")
	end
end

local wk = require("which-key")
wk.add({
	{ "<leader>D",  group = "database" },
	{ "<leader>Du", dbui_toggle, desc = "Toggle DB UI" },
	{
		"<leader>Ds",
		open_sql_float,
		desc = "SQL scratch (float)",
	},
	{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>",    desc = "Find buffer" },
	{ "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>",  desc = "Rename buffer" },
	{ "<leader>Dl", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
})
