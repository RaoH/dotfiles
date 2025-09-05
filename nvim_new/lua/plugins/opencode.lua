return {
	'NickvanDyke/opencode.nvim',
	dependencies = {
		'folke/snacks.nvim',
	},
	config = function()
		vim.g.opencode_opts = {
			win = {
				position = "float",
				enter = true, -- Do not enter the opencode window after opening it
				width = 0.6,
				border = 'rounded'
			},
		}
	end,
}
