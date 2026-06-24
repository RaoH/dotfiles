-- Custom handler for JSDoc @see and @link navigation
-- Works around TypeScript LSP not supporting go-to-definition for these

local M = {}

--- Extract symbol reference from JSDoc @link or @see under cursor
---@return string|nil
local function get_jsdoc_reference()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1

	-- Match {@link Symbol} or {@link Symbol description}
	for link_start, symbol in line:gmatch("(){@link%s+([%w_.#]+)") do
		local link_end = line:find("}", link_start) or #line
		if col >= link_start and col <= link_end then
			return symbol
		end
	end

	-- Match @see Symbol or @see {Symbol}
	local see_match = line:match("@see%s+{?([%w_.#]+)")
	if see_match then
		return see_match
	end

	return nil
end

--- Go to definition for JSDoc @link/@see references
function M.goto_jsdoc_link()
	local symbol = get_jsdoc_reference()

	if not symbol then
		-- Fall back to normal go-to-definition
		vim.lsp.buf.definition()
		return
	end

	-- Handle Class#method or Class.method syntax
	local parts = vim.split(symbol, "[#.]")
	local search_symbol = parts[#parts] -- Use the last part (method name) or full symbol

	-- Try workspace symbol search first
	vim.lsp.buf.workspace_symbol(search_symbol)
end

--- Enhanced definition that tries JSDoc links first
function M.smart_definition()
	local symbol = get_jsdoc_reference()

	if symbol then
		-- We're on a JSDoc link, search for it
		local parts = vim.split(symbol, "[#.]")
		local search_symbol = parts[#parts]

		-- Use picker for workspace symbols
		local ok, snacks = pcall(require, "snacks")
		if ok and snacks.picker then
			snacks.picker.lsp_workspace_symbols({ query = search_symbol })
		else
			vim.lsp.buf.workspace_symbol(search_symbol)
		end
	else
		-- Normal go-to-definition
		vim.lsp.buf.definition()
	end
end

return M
