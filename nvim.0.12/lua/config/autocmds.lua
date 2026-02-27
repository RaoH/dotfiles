vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc" },
	callback = function()
		vim.wo.spell = false
		vim.wo.conceallevel = 0
	end,
})

-- Override Neovim 0.12's built-in K mapping (virtual_lines toggle)
-- Show diagnostic float if diagnostics exist on the current line, otherwise LSP hover
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		vim.keymap.set("n", "K", function()
			local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
			if #diagnostics > 0 then
				vim.diagnostic.open_float({ border = "rounded" })
			else
				vim.lsp.buf.hover({ border = "rounded" })
			end
		end, { buffer = event.buf })
	end,
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(event)
		if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
			local ok = pcall(vim.cmd, "TSUpdate")
			if not ok then
				vim.notify("TSUpdate failed!", vim.log.levels.WARN)
			end
		end
	end,
})

-- Notify tmux of Neovim's CWD changes
-- Sets a pane-specific tmux variable that our opencode script can read
local in_tmux = (function()
	-- Check once on load if we're inside tmux
	vim.fn.system("tmux display-message -p ''")
	return vim.v.shell_error == 0
end)()

if in_tmux then
	vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
		pattern = "*",
		callback = function()
			local cwd = vim.fn.getcwd()
			vim.system({ "tmux", "set-option", "-p", "@nvim_cwd", cwd })
		end,
	})
end
