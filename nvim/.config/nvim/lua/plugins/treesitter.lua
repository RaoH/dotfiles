vim.pack.add({
	{ src = "https://github.com/windwp/nvim-ts-autotag.git" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter.git", rev = "main" },
})

require("nvim-ts-autotag").setup()

local parsers = {
	"diff",
	"gleam",
	"astro",
	"bash",
	"cmake",
	"cpp",
	"css",
	"elixir",
	"fish",
	"gitignore",
	"go",
	"graphql",
	"html",
	"http",
	"java",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"php",
	"query",
	"regex",
	"scss",
	"sql",
	"svelte",
	"tsx",
	"typescript",
	"vim",
	"yaml",
}

-- New nvim-treesitter API (0.12+)
require("nvim-treesitter").install(parsers)

-- Enable treesitter highlighting for all filetypes with a parser
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		-- Only enable if a parser exists for this filetype
		if pcall(vim.treesitter.start, args.buf) then
			-- Enable indentation
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

-- Incremental selection keymaps
local function select_node()
	local node = vim.treesitter.get_node()
	if node then
		local sr, sc, er, ec = node:range()
		vim.api.nvim_buf_set_mark(0, "<", sr + 1, sc, {})
		vim.api.nvim_buf_set_mark(0, ">", er + 1, ec - 1, {})
		vim.cmd("normal! gv")
	end
end

local function expand_selection()
	local node = vim.treesitter.get_node()
	if node then
		local parent = node:parent()
		if parent then
			local sr, sc, er, ec = parent:range()
			vim.api.nvim_buf_set_mark(0, "<", sr + 1, sc, {})
			vim.api.nvim_buf_set_mark(0, ">", er + 1, ec - 1, {})
			vim.cmd("normal! gv")
		end
	end
end

vim.keymap.set("n", "<C-space>", select_node, { desc = "Select treesitter node" })
vim.keymap.set("v", "<C-space>", expand_selection, { desc = "Expand to parent node" })
vim.keymap.set("v", "<bs>", "<Esc>", { desc = "Shrink selection" })
