vim.pack.add({"https://github.com/folke/snacks.nvim.git"})

local dashboard_settings = require("config.dashboard")

vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })

require('snacks').setup({
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
		statuscolumn = { enabled = true, folds = { open = true, git_hl = true } },
		words = { enabled = true },
		zen = { enabled = true },
		lazygit = { enabled = true },
		toggle = { enabled = true },
		terminal = { enabled = true },
		picker = {
			exclude = { -- add folder names here to exclude
				".git",
				"node_modules",
			},
			layout = {
				reverse = true,
				layout = {
					box = "horizontal",
					backdrop = false,
					width = 0.8,
					height = 0.9,
					border = "none",
					{
						box = "vertical",
						{ win = "list",  title = " Results ", title_pos = "center", border = "rounded" },
						{ win = "input", height = 1,          border = "rounded",   title = "{source} {live}", title_pos = "center" },
					},
					{
						win = "preview",
						width = 0.45,
						border = "rounded",
						title = " Preview ",
						title_pos = "center",
					},
				},
			},
		},
	})
