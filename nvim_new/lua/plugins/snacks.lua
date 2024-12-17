<<<<<<< Updated upstream
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


return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		git = { enabled = true },
		bigfile = { enabled = true },
		bufdelete = { enabled = true },
		dashboard = { preset = { header = logo } },
		indent = { animate = { enabled = false } },
		notifier = { enabled = true, timeout = 3000 },
		quickfile = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = false },
		words = { enabled = true },
		zen = { enabled = true },
	}
}
