return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local signs = {
			Error = require("config.icons").icons.diagnostics.Error,
			Warn = require("config.icons").icons.diagnostics.Warn,
			Hint = require("config.icons").icons.diagnostics.Hint,
			Info = require("config.icons").icons.diagnostics.Info,
		}

		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		require("trouble").setup({
			fold_open = "v",
			fold_closed = ">",
			indent_lines = false,
			signs = {
				error = signs.Error,
				warning = signs.Warn,
				hint = signs.Hint,
				info = signs.Info,
			},
		})
	end,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
}
