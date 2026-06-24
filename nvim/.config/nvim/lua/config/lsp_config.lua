vim.lsp.enable({
	--"biome",
	"css_variables",
	"cssls",
	"emmet_ls",
	"eslint",
	"gh_actions_ls",
	"html",
	"jsonls",
	"lua_ls",
	"svelte",
	"tailwindcss",
	"vtsls",
	"yamlls",
})

vim.diagnostic.config({
	--virtual_lines = true,
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})
