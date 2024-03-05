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
					blame = "<Leader>gb",
					-- Open file/folder in git repository
					browse = "<Leader>go",
				},
			}
			require("git").setup(opts)
		end,
	},

	{
		"echasnovski/mini.bufremove",
		config = function()
			local bufremove = function()
				local bd = require("mini.bufremove").delete
				if vim.bo.modified then
					local choice =
						vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
					if choice == 1 then -- Yes
						vim.cmd.write()
						bd(0)
					elseif choice == 2 then -- No
						bd(0, true)
					end
				else
					bd(0)
				end
			end

			local wk = require("which-key")

			wk.register({
				b = {
					name = "Buffer",
					d = { bufremove, "Delete buffer" },
					D = {
						function()
							require("mini.bufremove").delete(0, true)
						end,
						"Delete Buffer (Force)",
					},
					A = { "<Cmd>%bd|e#|bd#<Cr>", "Delete all buffers" },
				},
			}, { prefix = "<leader>" })
		end,
	},

	{
		"echasnovski/mini.hipatterns",
		event = "BufReadPre",
		config = function()
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
					--fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					--hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					--todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					--note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

					-- Highlight hex color strings (`#rrggbb`) using that color
					hex_color = hipatterns.gen_highlighter.hex_color(),
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
