--- https://github.com/EthanJWright/vs-tasks.nvim
return {
	"EthanJWright/vs-tasks.nvim",
	enabled = true,
	dependencies = {
		"nvim-lua/popup.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("vstask").setup({})

		local wk = require("which-key")

		wk.register({
			t = {
				name = "VS Task",
				a = { function()
					require("telescope").extensions.vstask.tasks()
				end, "Task" },
				i = {
					function()
						require("telescope").extensions.vstask.inputs()
					end,
					"Inputs",
				},
				h = {
					function()
						require("telescope").extensions.vstask.history()
					end,
					"History",
				},
				l = {
					function()
						require("telescope").extensions.vstask.launch()
					end,
					"Launch",
				},
			},
		}, { prefix = "<leader>" })
	end,
}
