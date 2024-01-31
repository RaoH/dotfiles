return {
	{ "windwp/nvim-autopairs" },
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			require("ibl").setup({
				exclude = { filetypes = { "dashboard" } },
				indent = { highlight = highlight },
				scope = {
					show_start = false,
				},
			})
		end,
		main = "ibl",
		opts = {},
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		config = function()
			local opts = {
				keymaps = {
					-- Open blame window
					-- ffeeerr
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
							--local utils = require("craftzdog.utils")
							local h, s, l = match:match("hsl%((%d+),? (%d+),? (%d+)%)")
							h, s, l = tonumber(h), tonumber(s), tonumber(l)
							--local hex_color = utils.hslToHex(h, s, l)
							--return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
						end,
					},
				},
			})
		end,
	},
}
