vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.pairs" },
	-- { src = "https://github.com/echasnovski/mini.ai" },
	{ src = "https://github.com/echasnovski/mini.surround" },
})

require("mini.pairs").setup()
-- require("mini.ai").setup()
require("mini.surround").setup()
