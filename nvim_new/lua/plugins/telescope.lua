return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local wk = require("which-key")
			wk.register({
				f = {
					name = "file",
					f = { "<cmd>Telescope git_files<cr>", "Find Git File" },
					r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false },
					["*"] = { "<cmd>Telescope find_files<cr>", "Find files", noremap = false },
				},
				["/"] = { "<cmd>Telescope live_grep<cr>", "which_key_ignore", noremap = false },
			}, { prefix = "<leader>" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
