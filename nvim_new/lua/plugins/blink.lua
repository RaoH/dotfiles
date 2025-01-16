local trigger_text = ";"

return {
	{
		"xzbdmw/colorful-menu.nvim",
		config = function()
			require("colorful-menu").setup({
				ls = {
					lua_ls = {
						-- Maybe you want to dim arguments a bit.
						arguments_hl = "@comment",
					},
					gopls = {
						-- When true, label for field and variable will format like "foo: Foo"
						-- instead of go's original syntax "foo Foo".
						add_colon_before_type = false,
					},
					-- for lsp_config or typescript-tools
					ts_ls = {
						extra_info_hl = "@comment",
					},
					vtsls = {
						extra_info_hl = "@comment",
					},
					["rust-analyzer"] = {
						-- Such as (as Iterator), (use std::io).
						extra_info_hl = "@comment",
					},
					clangd = {
						-- Such as "From <stdio.h>".
						extra_info_hl = "@comment",
					},
					roslyn = {
						extra_info_hl = "@comment",
					},
					basedpyright = {
						-- It is usually import path such as "os"
						extra_info_hl = "@comment",
					},

					-- If true, try to highlight "not supported" languages.
					fallback = true,
				},
				-- If the built-in logic fails to find a suitable highlight group,
				-- this highlight is applied to the label.
				fallback_highlight = "@variable",
				-- If provided, the plugin truncates the final displayed text to
				-- this width (measured in display cells). Any highlights that extend
				-- beyond the truncation point are ignored. Default 60.
				max_width = 60,
			})
		end,
	},

	{
		"saghen/blink.cmp",
		lazy = false,
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",
		config = function()
			require("blink-cmp").setup({
				keymap = { preset = "enter" },
				completion = {
					menu = {
						border = "rounded",
						draw = {
							columns = { { "kind_icon" }, { "label", gap = 1 } },
							components = {
								label = {
									width = { fill = true, max = 60 },
									text = require("colorful-menu").blink_components_text,
									highlight = require("colorful-menu").blink_components_highlight,
								},
							},
						},
					},
					documentation = {
						window = {
							border = "rounded",
						},
						auto_show = true,
						auto_show_delay_ms = 300,
					},
					-- ghost_text = { enabled = true }
				},

				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
				},

				sources = {
					default = { "lazydev", "lsp", "path", "snippets", "buffer", "luasnip" },
					cmdline = {},
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
								return item.kind == require("blink.cmp.types").CompletionItemKind.Snippet
							end, items)
						else
							return vim.tbl_filter(function(item)
								return item.kind ~= require("blink.cmp.types").CompletionItemKind.Snippet
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
						luasnip = {
							name = "luasnip",
							enabled = true,
							module = "blink.cmp.sources.luasnip",
							min_keyword_length = 2,
							fallbacks = { "snippets" },
							score_offset = 25,
						},
					},
				},
				snippets = {
					expand = function(snippet)
						require("luasnip").lsp_expand(snippet)
					end,
					active = function(filter)
						if filter and filter.direction then
							return require("luasnip").jumpable(filter.direction)
						end
						return require("luasnip").in_snippet()
					end,
					jump = function(direction)
						require("luasnip").jump(direction)
					end,
				},
				signature = { enabled = true },
			})
		end,
	},
}
