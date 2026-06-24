---@type vim.lsp.Config
return {
	cmd = { "vtsls", "--stdio" },
	init_options = {
		hostInfo = "neovim",
	},
	settings = {
		vtsls = {
			autoUseWorkspaceTsdk = true,
			experimental = {
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
		typescript = {
			globalPlugins = {
				{
					name = "typescript-svelte-plugin",
					enableForWorkspaceTypeScriptVersions = true,
				},
			},
			preferences = {
				importModuleSpecifier = "non-relative",
				importModuleSpecifierEnding = "minimal",
			},
			updateImportsOnFileMove = {
				enabled = "always",
			},
		},
		javascript = {
			preferences = {
				importModuleSpecifier = "non-relative",
				importModuleSpecifierEnding = "minimal",
			},
			updateImportsOnFileMove = {
				enabled = "always",
			},
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"svelte",
	},
	root_dir = function(bufnr, on_dir)
		-- The project root is where the LSP can be started from
		-- As stated in the documentation above, this LSP supports monorepos and simple projects.
		-- We select then from the project root, which is identified by the presence of a package
		-- manager lock file.
		local root_markers =
		{ "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", "deno.lock" }
		-- Give the root markers equal priority by wrapping them in a table
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
		    or vim.list_extend(root_markers, { ".git" })
		-- We fallback to the current working directory if no project root is found
		local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

		on_dir(project_root)
	end,
	on_attach = function(client, bufnr)
		-- vtsls cannot provide documentHighlight for .svelte files;
		-- let svelteserver handle it instead.
		if vim.bo[bufnr].filetype == "svelte" then
			client.server_capabilities.documentHighlightProvider = false
		end
	end,
}
