vim.pack.add({ "https://github.com/NickvanDyke/opencode.nvim.git" })

vim.g.opencode_opts = {
	prompts = {
		-- With an "Ask" item, the select menu can serve as the only entrypoint to all plugin-exclusive functionality, without numerous keymaps.
		ask = { prompt = "", ask = true, submit = true },
		explain = { prompt = "Explain @this and its context", submit = true },
		optimize = { prompt = "Optimize @this for performance and readability", submit = true },
		document = { prompt = "Add comments documenting @this", submit = true },
		test = { prompt = "Add tests for @this", submit = true },
		review = { prompt = "Review @this for correctness and readability", submit = true },
		diagnostics = { prompt = "Explain @diagnostics", submit = true },
		fix = { prompt = "Fix @diagnostics", submit = true },
		diff = { prompt = "Review the following git diff for correctness and readability: @diff", submit = true },
		buffer = { prompt = "@buffer" },
		this = { prompt = "@this" },
		commitmsg = {
			prompt = "@diff Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block. Add the files and make a git commit. Make sure we are on a branch that is not the main.",
			submit = true,
		},
		createbranchfromdiff = {
			prompt = "@diff Create a branch with a name that would represent the changes made. Use refac/, feature/, fix/ to start with. Make sure we base the branch from main.",
			ask = true,
			submit = true,
		},
	},
}
