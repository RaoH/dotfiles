return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({
				ensure_installed = {
					"stylua",
					"selene",
					"luacheck",
					"shellcheck",
					"shfmt",
					"tailwindcss-language-server",
					"svelte",
					"css-lsp",
					"netcoredbg",
					"css-variables-language-server",
					"csharp-language-server",
					"vtsls",
				},
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		lazy = false,
		config = function()
			require("mason-lspconfig").setup({
				automatic_enable = false,
				automatic_installation = true,
				ensure_installed = {
					"lua_ls",
					-- "csharp_ls",
					"cssls",
					"tailwindcss",
					"vtsls",
					"svelte",
				},
			})
		end,
	},
	-- {
	-- 	"jay-babu/mason-nvim-dap.nvim",
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("mason-nvim-dap").setup()
	-- 	end,
	-- },
}
