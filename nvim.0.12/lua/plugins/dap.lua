-- DAP (Debug Adapter Protocol) configuration for Node.js and SvelteKit
vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/igorlfs/nvim-dap-view" },
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
})

local dap = require("dap")
local dap_view = require("dap-view")

-- Setup dap-view
dap_view.setup({
	winbar = {
		show = true,
		sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
		default_section = "watches",
	},
	windows = {
		size = 15,
		position = "below",
		terminal = {
			size = 0.5,
			position = "left",
			-- Hide terminal for attach requests (external process already running)
			-- Terminal only shows for "launch" configurations
			hide = { "pwa-node", "pwa-chrome" },
		},
	},
})

-- Setup DAP signs using icons from config
local icons = require("config.icons").icons.dap
vim.fn.sign_define("DapBreakpoint", { text = icons.Breakpoint, texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = icons.BreakpointCondition, texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapBreakpointRejected", { text = icons.BreakpointRejected[1], texthl = "DiagnosticError" })
vim.fn.sign_define("DapStopped", { text = icons.Stopped[1], texthl = "DiagnosticWarn", linehl = "DapStoppedLine" })
vim.fn.sign_define("DapLogPoint", { text = icons.LogPoint, texthl = "DiagnosticInfo" })

-- Highlight for stopped line
vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#3d3d29" })

-- Configure js-debug-adapter (installed via Mason)
local js_debug_adapter_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"

-- pwa-node adapter for server-side debugging
dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = { js_debug_adapter_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
	},
}

-- pwa-chrome adapter for client-side debugging
dap.adapters["pwa-chrome"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = { js_debug_adapter_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
	},
}

-- Configurations for JavaScript/TypeScript/Svelte
for _, language in ipairs({ "typescript", "javascript", "svelte", "typescriptreact", "javascriptreact" }) do
	dap.configurations[language] = {
		-- Server-side: Attach to running node --inspect process
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach to Node (--inspect)",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
			skipFiles = { "<node_internals>/**", "**/node_modules/**" },
		},
		-- Server-side: Launch current file
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Current File (Node)",
			program = "${file}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
			skipFiles = { "<node_internals>/**", "**/node_modules/**" },
		},
		-- Client-side: Launch Chrome
		{
			type = "pwa-chrome",
			request = "launch",
			name = "Launch Chrome (Client)",
			url = "http://localhost:5173",
			webRoot = "${workspaceFolder}",
			sourceMaps = true,
			-- Important for SvelteKit/Vite client debugging
			sourceMapPathOverrides = {
				["webpack:///./~/*"] = "${workspaceFolder}/node_modules/*",
				["webpack:///./*"] = "${workspaceFolder}/*",
				["webpack:///*"] = "*",
				-- Vite specific
				["/@fs/*"] = "*",
				["/src/*"] = "${workspaceFolder}/src/*",
			},
			skipFiles = { "<node_internals>/**", "**/node_modules/**" },
		},
		-- Client-side: Attach to existing Chrome
		{
			type = "pwa-chrome",
			request = "attach",
			name = "Attach to Chrome",
			port = 9222,
			webRoot = "${workspaceFolder}",
			sourceMaps = true,
		},
	}
end

-- Auto-open/close dap-view
dap.listeners.after.event_initialized["dap_view"] = function()
	dap_view.open()
end
dap.listeners.before.event_terminated["dap_view"] = function()
	dap_view.close()
end
dap.listeners.before.event_exited["dap_view"] = function()
	dap_view.close()
end

-- Setup virtual text for inline variable display
require("nvim-dap-virtual-text").setup({
	enabled = true,
	enabled_commands = true, -- :DapVirtualTextToggle, :DapVirtualTextEnable, :DapVirtualTextDisable
	highlight_changed_variables = true,
	highlight_new_as_changed = false,
	show_stop_reason = true, -- Show exception info when stopped
	commented = true, -- Prefix with comment syntax (e.g., // variable = value)
	only_first_definition = false,
	all_references = true, -- Show at all variable references, not just definitions
	clear_on_continue = false,
	virt_text_pos = "inline", -- Neovim 0.10+ inline display
})

-- Pending watches: expressions queued before debug session starts
-- These will be added when the debugger first stops
local pending_watches = {}

-- Queue a watch expression to be added when debugger stops
-- Usage: :DapAddWatch expression
-- Or: require("plugins.dap").add_pending_watch("myVar")
local function add_pending_watch(expr)
	if not expr or #expr == 0 then
		vim.ui.input({ prompt = "Watch expression: " }, function(input)
			if input and #input > 0 then
				table.insert(pending_watches, input)
				vim.notify("Queued watch: " .. input, vim.log.levels.INFO)
			end
		end)
	else
		table.insert(pending_watches, expr)
		vim.notify("Queued watch: " .. expr, vim.log.levels.INFO)
	end
end

-- Add pending watches when debugger stops
dap.listeners.after.event_stopped["pending_watches"] = function()
	if #pending_watches > 0 then
		vim.defer_fn(function()
			local session = dap.session()
			if not session or not session.stopped_thread_id then
				return
			end

			local state = require("dap-view.state")
			local eval = require("dap-view.watches.eval")
			local expressions_to_add = vim.deepcopy(pending_watches)
			pending_watches = {}

			-- Run in coroutine since evaluate_expression uses async DAP requests
			coroutine.wrap(function()
				for _, expr in ipairs(expressions_to_add) do
					local ok, err = pcall(function()
						eval.evaluate_expression(expr, false, state.expr_count)
						state.expr_count = state.expr_count + 1
					end)
					if not ok then
						vim.notify("Failed to add watch '" .. expr .. "': " .. tostring(err), vim.log.levels.WARN)
					end
				end

				-- Switch to watches view to show the results after all evaluations complete
				vim.schedule(function()
					require("dap-view.views").switch_to_view("watches")
				end)
			end)()
		end, 300) -- Delay to ensure session is fully ready
	end
end

-- Create command for adding pending watches
vim.api.nvim_create_user_command("DapAddWatch", function(opts)
	add_pending_watch(opts.args)
end, { nargs = "?", desc = "Add watch expression (works before debugging starts)" })

-- Export for use in keybindings
return {
	add_pending_watch = add_pending_watch,
}
