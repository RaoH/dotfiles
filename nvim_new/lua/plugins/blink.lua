local trigger_text = ";"

return {
	"saghen/blink.cmp",
	lazy = false,
	dependencies = "rafamadriz/friendly-snippets",
	version = "*",
	opts = {
		keymap = { preset = "enter" },
		completion = {
			menu = {
				border = 'rounded'
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
			expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
			active = function(filter)
				if filter and filter.direction then
					return require('luasnip').jumpable(filter.direction)
				end
				return require('luasnip').in_snippet()
			end,
			jump = function(direction) require('luasnip').jump(direction) end,
		},
		signature = { enabled = true }
	},
	opts_extend = { "sources.default" },
}
