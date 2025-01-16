return {
	"imNel/monorepo.nvim",
	enabled = false,
	config = function()
		require("monorepo").setup({
			-- Your config here!
		})
	end,
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
}
