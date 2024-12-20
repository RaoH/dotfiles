local logo = [[
 ██▀███   ▄▄▄       ▒█████   ██░ ██ ▓█████▄ ▓█████ ██▒   █▓
 ▓██ ▒ ██▒▒████▄    ▒██▒  ██▒▓██░ ██▒▒██▀ ██▌▓█   ▀▓██░   █▒
 ▓██ ░▄█ ▒▒██  ▀█▄  ▒██░  ██▒▒██▀▀██░░██   █▌▒███   ▓██  █▒░
 ▒██▀▀█▄  ░██▄▄▄▄██ ▒██   ██░░▓█ ░██ ░▓█▄   ▌▒▓█  ▄  ▒██ █░░
 ░██▓ ▒██▒ ▓█   ▓██▒░ ████▓▒░░▓█▒░██▓░▒████▓ ░▒████▒  ▒▀█░
 ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░░ ▒░▒░▒░  ▒ ░░▒░▒ ▒▒▓  ▒ ░░ ▒░ ░  ░ ▐░
   ░▒ ░ ▒░  ▒   ▒▒ ░  ░ ▒ ▒░  ▒ ░▒░ ░ ░ ▒  ▒  ░ ░  ░  ░ ░░
   ░░   ░   ░   ▒   ░ ░ ░ ▒   ░  ░░ ░ ░ ░  ░    ░       ░░
   ░           ░  ░    ░ ░   ░  ░  ░   ░       ░  ░     ░
                                     ░                 ░
]]

local function command_exists(cmd)
	local handle = io.popen("command -v " .. cmd .. " 2>/dev/null")
	if handle then
		local result = handle:read("*a")
		handle:close()
		return result ~= ""
	end
	return false
end

local dashboard_layout_section = {
	{ section = "header" },
	{ section = "keys", gap = 1, padding = 1 },
	{
		pane = 2,
		icon = " ",
		desc = "Browse Repo",
		padding = 1,
		key = "b",
		action = function()
			Snacks.gitbrowse()
		end,
	},
	function()
		local in_git = Snacks.git.get_root() ~= nil
		local cmds = {}

		-- Add "gh" related commands only if the command exists
		if command_exists("gh") then
			table.insert(cmds, {
				title = "Notifications",
				cmd = "gh notify -s -a -n5",
				action = function()
					vim.ui.open("https://github.com/notifications")
				end,
				key = "n",
				icon = " ",
				height = 5,
				enabled = true,
			})

			table.insert(cmds, {
				title = "Open Issues",
				cmd = "gh issue list -L 3",
				key = "i",
				action = function()
					vim.fn.jobstart("gh issue list --web", { detach = true })
				end,
				icon = " ",
				height = 7,
			})

			table.insert(cmds, {
				icon = " ",
				title = "Open PRs",
				cmd = "gh pr list -L 3",
				key = "p",
				action = function()
					vim.fn.jobstart("gh pr list --web", { detach = true })
				end,
				height = 7,
			})
		end

		-- Always add Git Status since it does not depend on "gh"
		table.insert(cmds, {
			icon = " ",
			title = "Git Status",
			cmd = "git --no-pager diff --stat -B -M -C",
			height = 10,
		})
	end,
	{ section = "startup" },
}

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		git = { enabled = true },
		dim = { enabled = true },
		bigfile = { enabled = true },
		bufdelete = { enabled = true },
		dashboard = { preset = { header = logo }, sections = dashboard_layout_section },
		indent = { animate = { enabled = false } },
		notifier = { enabled = true, timeout = 3000 },
		quickfile = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = false },
		words = { enabled = true },
		zen = { enabled = true },
		lazygit = { enabled = true },
	},
}
