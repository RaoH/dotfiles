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
					--"typescript-language-server",
					"css-lsp",
					"netcoredbg",
					"azure-pipelines-language-server",
					"css-variables-language-server",
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

			lspconfig.cssls.setup({
				capabilities = capabilities,
				settings = {
					css = { validate = true, lint = {
						unknownAtRules = "ignore",
					} },
					scss = { validate = true, lint = {
						unknownAtRules = "ignore",
					} },
					less = { validate = true, lint = {
						unknownAtRules = "ignore",
					} },
				},
			})

			lspconfig.css_variables.setup({
				capabilities = capabilities,
				--cssVariables = {
				--	lookupFiles = { "**/*.less", "**/*.scss", "**/*.sass", "**/*.css" },
				--},
			})

			lspconfig.tsserver.setup({
				enabled = false,
				capabilities = capabilities,
				init_options = {
					preferences = {
						importModuleSpecifierPreference = "non-relative",
					},
				},
			})

			lspconfig.gleam.setup({})

			lspconfig.tsserver.setup({
				enabled = false,
				capabilities = capabilities,
				init_options = {
					preferences = {
						importModuleSpecifierPreference = "non-relative",
					},
				},
			})

			lspconfig.vtsls.setup({
				capabilities = capabilities,
				init_options = {
					complete_function_calls = true,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
					},
				},
			})

			lspconfig.eslint.setup({
				capabilities = capabilities,
				settings = {
					validate = "on",
				},
				root_dir = lspconfig.util.root_pattern(".eslintrc.js", ".eslintrc.json", "package.json"),
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
			})

			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})
		end,
	},
}
