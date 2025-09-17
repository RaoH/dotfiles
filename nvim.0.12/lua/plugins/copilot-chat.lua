vim.pack.add({
	{ src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim.git", branch = "main" },
	{ src = "https://github.com/zbirenbaum/copilot.lua.git", branch = "main" },
})

-- Run make tiktoken in the CopilotChat plugin directory if it exists
local copilot_chat_path = vim.fn.stdpath("data") .. "/pack/pack/start/CopilotChat.nvim"
if vim.fn.isdirectory(copilot_chat_path) == 1 then
	vim.fn.system("cd " .. copilot_chat_path .. " && make tiktoken")
end

require("CopilotChat").setup({
	debug = false, -- Enable debugging
	--model = "claude-3.5-sonnet",
	model = "claude-sonnet-4",
	window = {
		layout = "float",
	},
})
