vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },
	{ src = "https://github.com/xzbdmw/colorful-menu.nvim" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/onsails/lspkind.nvim" },
})

--local trigger_text = ";"
--
require("blink.cmp").setup({
	keymap = { preset = "enter" },
	completion = {
		menu = {
			border = "rounded",
			scrolloff = 1,
			scrollbar = false,
			draw = {
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 1 },
					{ "kind" },
					{ "source_name" },
				},
			},
		},
		documentation = {
			window = {
				border = "rounded",
				scrollbar = false,
				winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
			},
			auto_show = true,
			auto_show_delay_ms = 500,
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
		--default = { "lazydev", "lsp", "snippets", "buffer" },
		default = { "lsp", "buffer", "snippets" },
		per_filetype = {
			javascript = { "lsp", "snippets" },
			--lua = { "lazydev", "lsp", "snippets" },
			typescript = { "lsp", "snippets" },
			javascriptreact = { "lsp", "snippets" },
			typescriptreact = { "lsp", "snippets" },
			svelte = { "lsp", "snippets" },
		},
		-- transform_items = function(ctx, items)
		-- 	local _ = ctx
		-- 	local col = vim.api.nvim_win_get_cursor(0)[2]
		-- 	local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
		-- 	local trigger_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
		-- 	if trigger_pos then
		-- 		for _, item in ipairs(items) do
		-- 			-- Detect Emmet items by insertTextFormat = 2 and detail matching label
		-- 			-- Complete Emmet syntax patterns:
		-- 			local is_emmet = item.insertTextFormat == 2
		-- 				and item.detail
		-- 				and item.label
		-- 				and item.detail == item.label
		-- 				and (
		-- 					item.label:match("%.") -- classes: div.class
		-- 					or item.label:match("#") -- ids: div#id
		-- 					or item.label:match(">") -- children: div>p
		-- 					or item.label:match("%+") -- siblings: div+p
		-- 					or item.label:match("%^") -- climb-up: div>p^div
		-- 					or item.label:match("%*") -- multiplication: li*5
		-- 					or item.label:match("%(") -- grouping: (div>p)*3
		-- 					or item.label:match("%[") -- attributes: a[href]
		-- 					or item.label:match("{") -- text: a{Click me}
		-- 					or item.label:match("%$") -- numbering: li.item$*5
		-- 					or item.label:match("lorem") -- lorem ipsum
		-- 					or item.label:match("!") -- html:5 or !
		-- 					-- Also catch simple HTML tags and common abbreviations
		-- 					or item.label:match("^[a-zA-Z][a-zA-Z0-9]*$")
		-- 				)
		--
		-- 			if is_emmet then
		-- 				-- For Emmet items, find the actual end of the abbreviation on the line
		-- 				local full_line = vim.api.nvim_get_current_line()
		-- 				local abbreviation_end = col
		--
		-- 				-- If the item has curly braces, find the matching closing brace
		-- 				if item.label:match("{") then
		-- 					local closing_brace = full_line:find("}", trigger_pos + 1)
		-- 					if closing_brace then
		-- 						-- Include the closing brace in the replacement
		-- 						abbreviation_end = closing_brace
		-- 					end
		-- 				end
		--
		-- 				if item.textEdit then
		-- 					item.textEdit.range.start.character = trigger_pos - 1
		-- 					item.textEdit.range["end"].character = abbreviation_end
		-- 				end
		-- 			else
		-- 				item.textEdit = {
		-- 					newText = item.insertText or item.label,
		-- 					range = {
		-- 						start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
		-- 						["end"] = { line = vim.fn.line(".") - 1, character = col },
		-- 					},
		-- 				}
		-- 			end
		-- 		end
		-- 		return vim.tbl_filter(function(item)
		-- 			return item.kind == require("blink.cmp.types").CompletionItemKind.Snippet
		-- 		end, items)
		-- 	else
		-- 		return vim.tbl_filter(function(item)
		-- 			return item.kind ~= require("blink.cmp.types").CompletionItemKind.Snippet
		-- 		end, items)
		-- 	end
		-- end,
		providers = {
			-- lazydev = {
			-- 	name = "LazyDev",
			-- 	module = "lazydev.integrations.blink",
			-- 	-- make lazydev completions top priority (see `:h blink.cmp`)
			-- 	score_offset = 100,
			-- },
			lsp = {
				name = "LSP",
				score_offset = 100,
				module = "blink.cmp.sources.lsp",
				transform_items = function(_, items)
					for _, item in ipairs(items) do
						-- Lower priority for Emmet items (snippet format with matching detail/label)
						if item.insertTextFormat == 2 and item.detail == item.label then
							item.score_offset = -50 -- Lower priority than regular LSP
						end
					end
					return items
				end,
			},
			snippets = {
				score_offset = -10,
			},
		},
	},
	--	snippets = { preset = "" },
})
