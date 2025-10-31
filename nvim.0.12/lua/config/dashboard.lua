local M = {}

M.logo = [[
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

M.dashboard_layout_section = {
	{ section = "header" },
	{ section = "keys", gap = 1, padding = 1 },
	{
		pane = 2,
		icon = " ",
		desc = "Browse Repo",
		padding = 1,
		key = "b",
		enabled = true, -- gh_is_active(),
		action = function()
			Snacks.gitbrowse()
		end,
	},
	function()
		local in_git = Snacks.git.get_root() ~= nil
		local cmds = {}

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
			cmd = "gh issue list -L 3 2>/dev/null || echo 'Not in a GitHub repository'",
			key = "i",
			action = function()
				vim.fn.jobstart("gh issue list --web", { detach = true })
			end,
			icon = " ",
			height = 7,
		})

		table.insert(cmds, {
			icon = " ",
			title = "Open PRs",
			cmd = "gh pr list -L 3 2>/dev/null || echo 'Not in a GitHub repository'",
			key = "p",
			action = function()
				vim.fn.jobstart("gh pr list --web", { detach = true })
			end,
			height = 7,
		})

		-- Always add Git Status since it does not depend on "gh"
		table.insert(cmds, {
			icon = " ",
			title = "Git Status",
			cmd = "git --no-pager diff --stat -B -M -C 2>/dev/null || echo 'No changes'",
			height = 10,
		})

		return vim.tbl_map(function(cmd)
			return vim.tbl_extend("force", {
				pane = 2,
				section = "terminal",
				enabled = in_git,
				padding = 1,
				ttl = 5 * 60,
				indent = 3,
			}, cmd)
		end, cmds)
	end,
	--{ section = "startup" },
}

return M
