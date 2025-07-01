return {
	{
		"obsidian-nvim/obsidian.nvim",
		enabled = false,
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("obsidian").setup({
				workspaces = {
					{
						name = "BlackbyteVault",
						path = "~/obsidian/BlackbyteVault",
					},
				},
				picker = {
					name = "snacks.pick",
				},
				completion = {
					blink = true,
				},
			})
		end,
	},
}
