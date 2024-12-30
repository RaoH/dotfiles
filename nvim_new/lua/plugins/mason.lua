return {
	{
		"williamboman/mason.nvim",
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
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					-- "csharp_ls",
					"cssls",
					"tailwindcss",
					"vtsls",
				},
			})
		end,
		opts = {
			auto_install = true,
		},
	},
}
