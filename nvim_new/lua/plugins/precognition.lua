return {
	"tris203/precognition.nvim",
	event = "VeryLazy",
	enabled = false,
	config = function()
		require("precognition").setup({
			startVisible = false,
		})
	end,
}
