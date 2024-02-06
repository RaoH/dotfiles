return {
	"folke/edgy.nvim",
	config = function()
		require("symbols-outline.config").setup()
		local wk = require("which-key")

		wk.register({
			c = {
				s = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" },
			},
		}, { prefix = "<leader>" })
	end,
}
