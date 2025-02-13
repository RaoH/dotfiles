return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			--{ "github/copilot.vim" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			debug = false,       -- Enable debugging
			--model = "claude-3.5-sonnet",
			model = 'gemini-2.0-flash-001',
			window = {
				layout = "float",
			},
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
