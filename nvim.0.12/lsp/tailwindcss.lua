---@brief
--- https://github.com/tailwindlabs/tailwindcss-intellisense
---
--- Tailwind CSS Language Server can be installed via npm:
---
--- npm install -g @tailwindcss/language-server
local util = require("ui.util")

---@type vim.lsp.Config
return {
	cmd = { "tailwindcss-language-server", "--stdio" },
	-- filetypes copied and adjusted from tailwindcss-intellisense
	filetypes = {
		-- html
		"aspnetcorerazor",
		"astro",
		"astro-markdown",
		"blade",
		"clojure",
		"django-html",
		"htmldjango",
		"edge",
		"eelixir", -- vim ft
		"elixir",
		"ejs",
		"erb",
		"eruby", -- vim ft
		"gohtml",
		"gohtmltmpl",
		"haml",
		"handlebars",
		"hbs",
		"html",
		"htmlangular",
		"html-eex",
		"heex",
		"jade",
		"leaf",
		"liquid",
		"markdown",
		"mdx",
		"mustache",
		"njk",
		"nunjucks",
		"php",
		"razor",
		"slim",
		"twig",
		-- css
		"css",
		"less",
		"postcss",
		"sass",
		"scss",
		"stylus",
		"sugarss",
		-- js
		"javascript",
		"javascriptreact",
		"reason",
		"rescript",
		"typescript",
		"typescriptreact",
		-- mixed
		"vue",
		"svelte",
		"templ",
	},
	settings = {
		tailwindCSS = {
			validate = true,
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidScreen = "error",
				invalidVariant = "error",
				invalidConfigPath = "error",
				invalidTailwindDirective = "error",
				recommendedVariantOrder = "warning",
			},
			classAttributes = {
				"class",
				"className",
				"class:list",
				"classList",
				"ngClass",
			},
			includeLanguages = {
				eelixir = "html-eex",
				elixir = "phoenix-heex",
				eruby = "erb",
				heex = "phoenix-heex",
				htmlangular = "html",
				templ = "html",
			},
		},
	},
	before_init = function(_, config)
		if not config.settings then
			config.settings = {}
		end
		if not config.settings.editor then
			config.settings.editor = {}
		end
		if not config.settings.editor.tabSize then
			config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
		end
	end,
	workspace_required = true,
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)

		-- In a monorepo, prefer the nearest package.json that references tailwindcss
		-- over .git (which would resolve to the repo root where tailwindcss is not installed).
		-- We check for package.json with "tailwindcss" first, then fall back to config files,
		-- then .git.
		local pkg_root = nil
		local pkg_files = vim.fs.find({ "package.json" }, { path = fname, upward = true, limit = math.huge })
		for _, pkg in ipairs(pkg_files or {}) do
			for line in io.lines(pkg) do
				if line:find("tailwindcss") then
					pkg_root = vim.fs.dirname(pkg)
					break
				end
			end
			if pkg_root then
				break
			end
		end

		if pkg_root then
			on_dir(pkg_root)
			return
		end

		-- Fallback: generic config files and .git
		local root_files = {
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"tailwind.config.ts",
			"postcss.config.js",
			"postcss.config.cjs",
			"postcss.config.mjs",
			"postcss.config.ts",
			".git",
		}
		root_files = util.root_markers_with_field(root_files, { "mix.lock", "Gemfile.lock" }, "tailwind", fname)
		on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
	end,
}
