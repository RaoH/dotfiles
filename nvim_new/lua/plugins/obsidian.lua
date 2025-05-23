return {
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "BlackbyteVault",
					path = "~/obsidian/BlackbyteVault",
				},
			},
			picker = {
				name = 'snacks.pick'
			},
			completion = {
				blink = true,
			}
		},
	},
}
