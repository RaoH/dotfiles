return {
	{
		'stevearc/oil.nvim',
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup()
			local wk = require("which-key")
			wk.register({
				f = {
					o = { "<cmd>Oil<cr>", "Open in parent directory" },
				},
			}, { prefix = "<leader>" })
		end
	}
}
