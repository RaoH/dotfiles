return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = require("config.icons").icons
						.diagnostics.Error,
						[vim.diagnostic.severity.WARN] = require("config.icons").icons
						.diagnostics.Warn,
						[vim.diagnostic.severity.HINT] = require("config.icons").icons
						.diagnostics.Hint,
						[vim.diagnostic.severity.INFO] = require("config.icons").icons
						.diagnostics.Info,
					},
				},
			},
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.csharp_ls.setup({})

			lspconfig.lua_ls.setup({
				inlay_hints = { enabled = true },
				capabilities = capabilities,
			})

			lspconfig.html.setup({
				capabilities = capabilities,
			})

			lspconfig.jsonls.setup({
				capabilities = capabilities,
			})

			lspconfig.yamlls.setup({
				capabilities = capabilities,
			})

			lspconfig.kulala_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.cssls.setup({
				capabilities = capabilities,
				settings = {
					css = {
						validate = true,
						lint = {
							unknownAtRules = "ignore",
						},
					},
					scss = {
						validate = true,
						lint = {
							unknownAtRules = "ignore",
						},
					},
					less = {
						validate = true,
						lint = {
							unknownAtRules = "ignore",
						},
					},
				},
			})

			lspconfig.css_variables.setup({
				capabilities = capabilities,
				cssVariables = {
					lookupFiles = { "**/*.less", "**/*.scss", "**/*.sass", "**/*.css" },
				},
			})

			lspconfig.svelte.setup({
				settings = {
					svelte = {
						plugin = {
							typescript = {
								enable = true,
								diagnostics = { enable = true },
								hover = { enable = true },
								completions = { enable = true }
							}
						}
					}
				}
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
				--filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			})

			lspconfig.eslint.setup({
				capabilities = capabilities,
				settings = {
					validate = "on",
				},
				root_dir = lspconfig.util.root_pattern(
					".eslintrc.js",
					".eslintrc.json",
					"package.json",
					".eslintrc.cjs"
				),
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
			})

			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})
		end,
	},
}
