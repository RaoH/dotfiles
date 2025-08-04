return {
	'NickvanDyke/opencode.nvim',
	dependencies = {
		'folke/snacks.nvim',
	},
	config = function()
		require('opencode').setup({
			win = {
				position = "float",
				enter = true, -- Do not enter the opencode window after opening it
				width = 0.6,
				border = 'rounded'
			},

		})
	end,
}
