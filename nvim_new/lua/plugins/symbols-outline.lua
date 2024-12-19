return {
	"folke/edgy.nvim",
	enabled = false,
	config = function()
		require("symbols-outline.config").setup()
	end,
}
