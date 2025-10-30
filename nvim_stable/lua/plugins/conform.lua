return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			local conform = require("conform")

			require("conform.formatters.prettier").cwd = require("conform.util").root_file({
				".custom-config.json",
				-- These are the builtins
				".prettierrc",
				".prettierrc.json",
				".prettierrc.yml",
				".prettierrc.yaml",
				".prettierrc.json5",
				".prettierrc.js",
				".prettierrc.cjs",
				".prettierrc.toml",
				"prettier.config.js",
				"prettier.config.cjs",
				"package.json",
			})

			conform.setup({
				formatters = {
					kulala = {
						command = "kulala-fmt",
						args = { "format", "$FILENAME" },
						stdin = false,
					},
				},
				formatters_by_ft = {
					http = { "kulala" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					svelte = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					graphql = { "prettier" },
					lua = { "stylua" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
			})
		end,
	},
}
