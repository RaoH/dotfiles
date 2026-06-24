vim.pack.add({
	{ src = "https://github.com/josephschmitt/pj.nvim.git" },
	{ src = "https://github.com/folke/persistence.nvim" },
})

local persistence = require("persistence")

persistence.setup({
	dir = vim.fn.stdpath("state") .. "/sessions/",
	need = 1, -- minimum number of buffers to save
})

-- Save session when directory is about to change
vim.api.nvim_create_autocmd("DirChangedPre", {
	pattern = "global",
	callback = function()
		-- Save session for current project before leaving
		persistence.save()
	end,
})

-- Clean up buffers and load new session after directory change
vim.api.nvim_create_autocmd("DirChanged", {
	pattern = "global",
	callback = function()
		-- Schedule to let any pending UI operations complete first
		vim.schedule(function()
			-- Close all buffers (including dashboard) from old project
			vim.cmd("silent! %bdelete!")
			-- Check if session exists for new directory
			local session_file = persistence.current()
			if session_file and vim.uv.fs_stat(session_file) then
				persistence.load()
			else
				-- No session for this project, show dashboard
				Snacks.dashboard()
			end
		end)
	end,
})

-- Re-enable filetype and treesitter after session load
vim.api.nvim_create_autocmd("User", {
	pattern = "PersistenceLoadPost",
	callback = function()
		-- Schedule to run after session is fully loaded
		vim.schedule(function()
			-- Reload ALL buffers that have files but no filetype
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then
					local name = vim.api.nvim_buf_get_name(buf)
					if name and name ~= "" and vim.bo[buf].buftype == "" and vim.bo[buf].filetype == "" then
						-- Set buffer and reload it to trigger FileType and treesitter
						vim.api.nvim_buf_call(buf, function()
							vim.cmd("silent! edit")
						end)
					end
				end
			end
		end)
	end,
})

-- Custom session picker with delete support using Snacks
local function session_picker()
	local sessions_dir = vim.fn.stdpath("state") .. "/sessions/"
	local sessions = vim.fn.glob(sessions_dir .. "*.vim", true, true)

	-- Sort by modification time (newest first)
	table.sort(sessions, function(a, b)
		local stat_a = vim.uv.fs_stat(a)
		local stat_b = vim.uv.fs_stat(b)
		if stat_a and stat_b then
			return stat_a.mtime.sec > stat_b.mtime.sec
		end
		return false
	end)

	-- Build items for picker
	local items = {}
	for _, session in ipairs(sessions) do
		local file = session:sub(#sessions_dir + 1, -5) -- remove dir prefix and .vim suffix
		local dir = file:gsub("%%", "/")
		-- Handle Windows drive letters
		if jit.os:find("Windows") then
			dir = dir:gsub("^(%w)/", "%1:/")
		end
		table.insert(items, {
			text = vim.fn.fnamemodify(dir, ":~"),
			file = session,
			dir = dir,
		})
	end

	if #items == 0 then
		vim.notify("No sessions found", vim.log.levels.INFO)
		return
	end

	Snacks.picker({
		title = "Sessions",
		items = items,
		format = "text",
		confirm = function(picker, item)
			picker:close()
			if item then
				vim.fn.chdir(item.dir)
				persistence.load()
			end
		end,
		actions = {
			delete_session = function(picker, item)
				if item then
					vim.ui.select({ "Yes", "No" }, {
						prompt = "Delete session for " .. item.text .. "?",
					}, function(choice)
						if choice == "Yes" then
							os.remove(item.file)
							vim.notify("Deleted session: " .. item.text, vim.log.levels.INFO)
							picker:close()
							-- Reopen picker to refresh list
							vim.schedule(session_picker)
						end
					end)
				end
			end,
		},
		win = {
			input = {
				keys = {
					["<C-d>"] = { "delete_session", mode = { "n", "i" }, desc = "Delete session" },
				},
			},
		},
	})
end

-- Expose for keymaps
_G.SessionPicker = session_picker

require("pj").setup({
	behavior = {
		session_manager = nil, -- we handle sessions ourselves via autocmds
		cd_scope = "global",
	},
})
