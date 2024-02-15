return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-smart-history.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		config = function()
			local telescope = require("telescope")

			telescope.load_extension("fzf")

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
	{},
	-- {
	-- 	"nvim-telescope/telescope-smart-history.nvim",
	-- 	config = function()
	-- 		local telescope = require("telescope")
	-- 		telescope.setup({
	-- 			defaults = {
	-- 				history = {
	-- 					path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
	-- 					limit = 100,
	-- 				},
	-- 			},
	-- 		})

	-- 		telescope.load_extension("smart_history")
	-- 	end,
	-- },
	{
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
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
