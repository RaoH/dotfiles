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
					"typescript-language-server",
					"css-lsp",
					"netcoredbg",
					"azure-pipelines-language-server",
				},
			})
			vim.keymap.set("n", "<leader>cm", ":Mason<Return>", {})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					--"csharpls",
					"cssls",
					"tsserver",
					"tailwindcss",
				},
			})
		end,
		opts = {
			auto_install = true,
		},
	},

	{
		"neovim/nvim-lspconfig",
		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
					-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
					-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
					-- prefix = "icons",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = require("config.icons").icons.diagnostics.Error,
						[vim.diagnostic.severity.WARN] = require("config.icons").icons.diagnostics.Warn,
						[vim.diagnostic.severity.HINT] = require("config.icons").icons.diagnostics.Hint,
						[vim.diagnostic.severity.INFO] = require("config.icons").icons.diagnostics.Info,
					},
				},
			},
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				inlay_hints = { enabled = true },
				capabilities = capabilities,
			})
			lspconfig.html.setup({
				capabilities = capabilities,
			})
			lspconfig.tsserver.setup({
				capabilities = capabilities,
			})

			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})

			local wk = require("which-key")
			wk.register({
				c = {
					name = "code",
					a = { "Action" },
				},
			}, { prefix = "<leader>" })

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
