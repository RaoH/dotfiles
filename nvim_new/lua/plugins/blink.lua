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
									local kind = require("lspkind").symbol_map
									    [item.kind] or ""
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
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},

			cmdline = { enabled = false },

			signature = {
				enabled = true,
				window = { border = "rounded" },
			},
			sources = {
				default = { 'lazydev', 'lsp', 'snippets', 'buffer' },
				per_filetype = {
					javascript = { 'lazydev', 'lsp', 'snippets' },
					typescript = { 'lazydev', 'lsp', 'snippets' },
					javascriptreact = { 'lazydev', 'lsp', 'snippets' },
					typescriptreact = { 'lazydev', 'lsp', 'snippets' },
					vue = { 'lazydev', 'lsp', 'snippets' },
					svelte = { 'lazydev', 'lsp', 'snippets' },
				},
				transform_items = function(ctx, items)
					local _ = ctx
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
					local trigger_pos = before_cursor:find(trigger_text ..
						"[^" .. trigger_text .. "]*$")
					if trigger_pos then
						for _, item in ipairs(items) do
							-- Detect Emmet items by insertTextFormat = 2 and detail matching label
							-- Complete Emmet syntax patterns:
							local is_emmet = item.insertTextFormat == 2 and
							    item.detail and item.label and
							    item.detail == item.label and
							    (item.label:match("%.") or -- classes: div.class
								    item.label:match("#") or -- ids: div#id
								    item.label:match(">") or -- children: div>p
								    item.label:match("%+") or -- siblings: div+p
								    item.label:match("%^") or -- climb-up: div>p^div
								    item.label:match("%*") or -- multiplication: li*5
								    item.label:match("%(") or -- grouping: (div>p)*3
								    item.label:match("%[") or -- attributes: a[href]
								    item.label:match("{") or -- text: a{Click me}
								    item.label:match("%$") or -- numbering: li.item$*5
								    item.label:match("lorem") or -- lorem ipsum
								    item.label:match("!") or -- html:5 or !
								    -- Also catch simple HTML tags and common abbreviations
								    item.label:match("^[a-zA-Z][a-zA-Z0-9]*$"))

							if is_emmet then
								-- For Emmet items, find the actual end of the abbreviation on the line
								local full_line = vim.api.nvim_get_current_line()
								local abbreviation_end = col

								-- If the item has curly braces, find the matching closing brace
								if item.label:match("{") then
									local closing_brace = full_line:find("}",
										trigger_pos + 1)
									if closing_brace then
										-- Include the closing brace in the replacement
										abbreviation_end = closing_brace
									end
								end

								if item.textEdit then
									item.textEdit.range.start.character = trigger_pos -
									    1
									item.textEdit.range["end"].character =
									    abbreviation_end
								end
							else
								item.textEdit = {
									newText = item.insertText or item.label,
									range = {
										start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
										["end"] = { line = vim.fn.line(".") - 1, character = col },
									},
								}
							end
						end
						return vim.tbl_filter(function(item)
							return item.kind ==
							    require('blink.cmp.types').CompletionItemKind.Snippet
						end, items)
					else
						return vim.tbl_filter(function(item)
							return item.kind ~=
							    require('blink.cmp.types').CompletionItemKind.Snippet
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
					lsp = {
						name = "LSP",
						module = "blink.cmp.sources.lsp",
						-- Boost Emmet completions when they appear
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								-- Boost Emmet items (snippet format with matching detail/label)
								if item.insertTextFormat == 2 and item.detail == item.label then
									item.score_offset = 50 -- Higher priority than default
								end
							end
							return items
						end,
					},
				},
			},
			snippets = { preset = 'luasnip' },
		},
	},
}
