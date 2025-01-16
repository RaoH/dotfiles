local dashboard_settings = require("config.dashboard")

vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuratikkon section below
		git = { enabled = true },
		dim = { enabled = true },
		bigfile = { enabled = true },
		bufdelete = { enabled = true },
		dashboard = {
			preset = { header = dashboard_settings.logo },
			sections = dashboard_settings.dashboard_layout_section,
		},
		indent = {
			animate = { enabled = false },
			indent = {
				hl = {
					"RainbowRed",
					"RainbowYellow",
					"RainbowBlue",
					"RainbowOrange",
					"RainbowGreen",
					"RainbowViolet",
					"RainbowCyan",
				},
			},
		},
		notifier = { enabled = true, timeout = 3000 },
		quickfiles = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		zen = { enabled = true },
		lazygit = { enabled = true },
		toggle = { enabled = true },
		terminal = { enabled = true },
	},
}
