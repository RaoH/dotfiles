local trigger_text = ";"

return {
	{
		'saghen/blink.cmp',
		dependencies = { 'rafamadriz/friendly-snippets', { 'L3MON4D3/LuaSnip', version = 'v2.*' } },

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
				},
				documentation = {
					window = {
						border = "rounded",
					},
					auto_show = true,
					auto_show_delay_ms = 300,
				},
				trigger = {
					show_on_keyword = true,
				}

				-- ghost_text = { enabled = true }
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			cmdline = { enabled = false },
			sources = {
				--default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
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
							vim.notify_once("Testing")
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
					-- snippets = {
					-- 	should_show_items = function(ctx)
					-- 		vim.notify('triggered')
					-- 		return ctx.trigger.initial_kind ~= ';'
					-- 	end
					-- }
				},
			},
			snippets = { preset = 'luasnip' },
			signature = { enabled = true }
		},
	},
	-- 	{
	-- 		"xzbdmw/colorful-menu.nvim",
	-- 		config = function()
	-- 			require("colorful-menu").setup()
	-- 		end,
	-- 	},
	-- }

}
