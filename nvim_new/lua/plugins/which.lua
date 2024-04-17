return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")
		wk.register({
			b = {
				name = "Buffer",
				c = { "<cmd>bd!<cr>", "Close current buffer" },
				D = { "<cmd>%bd|e#|bd#<cr>", "Delete all buffers" },
			},
		}, { prefix = "<leader>" })
	end,
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
}
