local js_based_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
}

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"mxsdev/nvim-dap-vscode-js",
			-- build debugger from source
			-- {
			-- 	"microsoft/vscode-js-debug",
			-- 	version = "1.x",
			-- 	build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
			-- },
		},
		keys = {
			-- normal mode is default
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
			},
			{
				"<leader>da",
				function()
					if vim.fn.filereadable(".vscode/launch.json") then
						local dap_vscode = require("dap.ext.vscode")
						dap_vscode.load_launchjs(nil, {
							["pwa-node"] = js_based_languages,
							["chrome"] = js_based_languages,
							["pwa-chrome"] = js_based_languages,
						})
					end
					require("dap").continue()
				end,
				desc = "Run with Args",
			},
		},
		config = function()
			local dap = require("dap")
			-- setup adapters
			require("dap-vscode-js").setup({
				debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
				debugger_cmd = { "js-debug-adapter" },
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
			})
			for _, adapter in pairs({ "pwa-node", "pwa-chrome", "node-terminal" }) do
				dap.adapters[adapter] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "js-debug-adapter",
						args = { "${port}" },
					},
				}
			end

			for name, sign in pairs(require("config.icons").icons.dap) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end

			-- language config
			for _, language in ipairs({ "typescript", "javascript" }) do
				dap.configurations[language] = {
					{
						name = "Launch",
						type = "pwa-node",
						request = "launch",
						program = "${file}",
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						skipFiles = { "<node_internals>/**" },
						protocol = "inspector",
						console = "integratedTerminal",
					},
					{
						name = "Attach to node process",
						type = "pwa-node",
						request = "attach",
						rootPath = "${workspaceFolder}",
						processId = require("dap.utils").pick_process,
						attachSimplePort = 9229,
						console = "integratedTerminal",
						skipFiles = { "<node_internals>/**" },
						sourceMaps = true,
						-- protocol = 'inspector',
						-- sourceMaps = true,
						-- skipFiles = { '<node_internals>/**' },
					},
					{
						name = "Debug Main Process (Electron)",
						type = "pwa-node",
						request = "launch",
						program = "${workspaceFolder}/node_modules/.bin/electron",
						args = {
							"${workspaceFolder}/dist/index.js",
						},
						outFiles = {
							"${workspaceFolder}/dist/*.js",
						},
						resolveSourceMapLocations = {
							"${workspaceFolder}/dist/**/*.js",
							"${workspaceFolder}/dist/*.js",
						},
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						skipFiles = { "<node_internals>/**" },
						protocol = "inspector",
						console = "integratedTerminal",
					},
				}
			end

			require("dapui").setup()
			local dapui = require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({ reset = true })
			end
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close
		end,
	},
}
