---@brief
---
--- https://github.com/sveltejs/language-tools/tree/master/packages/language-server
---
--- Note: assuming that [ts_ls](#ts_ls) is setup, full JavaScript/TypeScript support (find references, rename, etc of symbols in Svelte files when working in JS/TS files) requires per-project installation and configuration of [typescript-svelte-plugin](https://github.com/sveltejs/language-tools/tree/master/packages/typescript-plugin#usage).
---
--- `svelte-language-server` can be installed via `npm`:
--- ```sh
--- npm install -g svelte-language-server
--- ```

---@type vim.lsp.Config
return {
	cmd = { "svelteserver", "--stdio" },
	filetypes = { "svelte" },
	settings = {
		svelte = {
			plugin = {
				svelte = {
					compilerWarnings = {
						["a11y-accesskey"] = "ignore",
						["a11y-aria-activedescendant-has-tabindex"] = "ignore",
						["a11y-aria-attributes"] = "ignore",
						["a11y-autofocus"] = "ignore",
						["a11y-click-events-have-key-events"] = "ignore",
						["a11y-consider-explicit-label"] = "ignore",
						["a11y_consider_explicit_label"] = "ignore",
						["a11y-distracting-elements"] = "ignore",
						["a11y-hidden"] = "ignore",
						["a11y-img-redundant-alt"] = "ignore",
						["a11y-interactive-supports-focus"] = "ignore",
						["a11y-invalid-attribute"] = "ignore",
						["a11y-label-has-associated-control"] = "ignore",
						["a11y-media-has-caption"] = "ignore",
						["a11y-misplaced-role"] = "ignore",
						["a11y-misplaced-scope"] = "ignore",
						["a11y-missing-attribute"] = "ignore",
						["a11y-missing-content"] = "ignore",
						["a11y-mouse-events-have-key-events"] = "ignore",
						["a11y-no-abstract-role"] = "ignore",
						["a11y-no-interactive-element-to-noninteractive-role"] = "ignore",
						["a11y-no-noninteractive-element-interactions"] = "ignore",
						["a11y-no-noninteractive-element-to-interactive-role"] = "ignore",
						["a11y-no-noninteractive-tabindex"] = "ignore",
						["a11y-no-redundant-roles"] = "ignore",
						["a11y-no-static-element-interactions"] = "ignore",
						["a11y-positive-tabindex"] = "ignore",
						["a11y-role-has-required-aria-props"] = "ignore",
						["a11y-role-supports-aria-props"] = "ignore",
						["a11y-structure"] = "ignore",
						["a11y-unknown-aria-attribute"] = "ignore",
						["a11y-unknown-role"] = "ignore",
					},
				},
			},
		},
		typescript = {
			preferences = {
				importModuleSpecifier = "non-relative",
				importModuleSpecifierEnding = "minimal",
			},
		},
		javascript = {
			preferences = {
				importModuleSpecifier = "non-relative",
				importModuleSpecifierEnding = "minimal",
			},
		},
	},
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		-- Svelte LSP only supports file:// schema. https://github.com/sveltejs/language-tools/issues/2777
		if vim.uv.fs_stat(fname) ~= nil then
			-- Use nearest svelte.config.js or package.json so pnpm workspace packages
			-- are resolved from the correct app/package root (not the monorepo root).
			local project_root = vim.fs.root(bufnr, { "svelte.config.js", "package.json" })
				or vim.fn.getcwd()
			on_dir(project_root)
		end
	end,
	on_attach = function(client, bufnr)
		-- Workaround to trigger reloading JS/TS files
		-- See https://github.com/sveltejs/language-tools/issues/2008
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.js", "*.ts" },
			group = vim.api.nvim_create_augroup("lspconfig.svelte", {}),
			callback = function(ctx)
				-- internal API to sync changes that have not yet been saved to the file system
				client:notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
			end,
		})
		vim.api.nvim_buf_create_user_command(bufnr, "LspMigrateToSvelte5", function()
			client:exec_cmd({
				title = "Migrate Component to Svelte 5 Syntax",
				command = "migrate_to_svelte_5",
				arguments = { vim.uri_from_bufnr(bufnr) },
			})
		end, { desc = "Migrate Component to Svelte 5 Syntax" })
	end,
}
