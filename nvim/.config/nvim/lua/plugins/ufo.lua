vim.pack.add({
	{ src = "https://github.com/kevinhwang91/nvim-ufo.git" },
	{ src = "https://github.com/kevinhwang91/promise-async.git" },
})

vim.o.foldcolumn = "0" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99 -- Start with all folds open
vim.o.foldenable = true
vim.o.fillchars = "eob: ,fold: ,foldopen:v,foldsep: ,foldclose:>"

require("ufo").setup({
	provider_selector = function()
		return { "treesitter", "indent" }
	end,
})
