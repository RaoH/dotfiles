vim.pack.add({"https://github.com/mason-org/mason.nvim"})
vim.pack.add({"https://github.com/mason-org/mason-lspconfig.nvim"})


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

