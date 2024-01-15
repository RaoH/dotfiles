return {
	{ "windwp/nvim-autopairs" },
	{ "windwp/nvim-ts-autotag" },
	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		config = function()
			local opts = {
				keymaps = {
					-- Open blame window
					blame = "<Leader>gb",
					-- Open file/folder in git repository
					browse = "<Leader>go",
				},
			}
			require("git").setup(opts)
		end,
	},
	{
		"echasnovski/mini.hipatterns",
		event = "BufReadPre",
		config = function()
			require("mini.hipatterns").setup({
				highlighters = {
					hsl_color = {
						pattern = "hsl%(%d+,? %d+,? %d+%)",
						group = function(_, match)
							local utils = require("craftzdog.utils")
							local h, s, l = match:match("hsl%((%d+),? (%d+),? (%d+)%)")
							h, s, l = tonumber(h), tonumber(s), tonumber(l)
							local hex_color = utils.hslToHex(h, s, l)
							return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
						end,
					},
				},
			})
		end,
	},
}
