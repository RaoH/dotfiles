vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })
require("lualine").setup({
	options = {
		theme = "catppuccin-mocha",
	},
	sections = {
		lualine_x = {
			{
				function()
					return require("noice").api.statusline.mode.get()
				end,
				cond = function()
					return package.loaded["noice"] and require("noice").api.statusline.mode.has()
				end,
				color = { fg = "#ff9e64" },
			},
		},
	},
})
