local trigger_text = ";"

return {
	{
		'saghen/blink.cmp',
		dependencies = { "xzbdmw/colorful-menu.nvim", 'rafamadriz/friendly-snippets', "onsails/lspkind.nvim", },

		-- use a release tag to download pre-built binaries
		version = '*',
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "enter" },
			completion = {
				menu = {
					border = "rounded",

					cmdline_position = function()
						if vim.g.ui_cmdline_pos ~= nil then
							local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
							return { pos[1] - 1, pos[2] }
						end
						local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
						return { vim.o.lines - height, 0 }
					end,

					draw = {
						columns = {
							{ "kind_icon", "label", gap = 1 },
							{ "kind" },
						},
						components = {
							kind_icon = {
								text = function(item)
									local kind = require("lspkind").symbol_map[item.kind] or ""
									return kind .. " "
								end,
								highlight = "CmpItemKind",
							},
							label = {
								text = function(item)
									return item.label
								end,
								highlight = "CmpItemAbbr",
							},
							kind = {
								text = function(item)
									return item.kind
								end,
								highlight = "CmpItemKind",
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					window = { border = "rounded" },
				},
				-- documentation = {
				-- 	window = {
				-- 		border = "rounded",
				-- 	},
				-- 	auto_show = true,
				-- },
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},

			kcmdline = { enabled = false },

			signature = {
				enabled = true,
				window = { border = "rounded" },
			},
			sources = {
				default = { 'lazydev', 'lsp', 'snippets', 'buffer' },
				transform_items = function(ctx, items)
					local _ = ctx
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
					local trigger_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
					if trigger_pos then
						for _, item in ipairs(items) do
							item.textEdit = {
								newText = item.insertText or item.label,
								range = {
									start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
									["end"] = { line = vim.fn.line(".") - 1, character = col },
								},
							}
						end
						return vim.tbl_filter(function(item)
							return item.kind == require('blink.cmp.types').CompletionItemKind.Snippet
						end, items)
					else
						return vim.tbl_filter(function(item)
							return item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet
						end, items)
					end
				end,
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},
			snippets = { preset = 'luasnip' },
		},
	},
}
