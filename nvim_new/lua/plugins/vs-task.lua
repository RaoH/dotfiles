--- https://github.com/EthanJWright/vs-tasks.nvim
return {
	"EthanJWright/vs-tasks.nvim",
	dependencies = {
		"nvim-lua/popup.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("vstask").setup({})
		-- nnoremap <Leader>ta :lua require("telescope").extensions.vstask.tasks()<CR>
		-- nnoremap <Leader>ti :lua require("telescope").extensions.vstask.inputs()<CR>
		-- nnoremap <Leader>th :lua require("telescope").extensions.vstask.history()<CR>
		-- nnoremap <Leader>tl :lua require('telescope').extensions.vstask.launch()<cr>
	end,
}
