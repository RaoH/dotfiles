return {
	-- {
	-- 	"windwp/nvim-autopairs",
	-- 	event = { "InsertEnter" },
	-- 	config = function()
	-- 		local autopairs = require("nvim-autopairs")
	-- 		autopairs.setup({
	-- 			check_ts = true,
	-- 		})
	-- 	end,
	-- },
	{
		"echasnovski/mini.pairs",
		version = false,
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"echasnovski/mini.ai",
		version = false,
		config = function()
			require("mini.ai").setup()
		end,
	},
	{
		"echasnovski/mini.surround",
		version = false,
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
