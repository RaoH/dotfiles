local settings = require("config.which_key")

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		require("which-key").add(settings.keymap)
	end,
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
}
