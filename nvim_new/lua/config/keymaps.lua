-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

--Split window
keymap.set("n", "ms", ":split<Return>", opts)
keymap.set("n", "mv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "mh", "<C-w>h")
keymap.set("n", "mk", "<C-w>k")
keymap.set("n", "mj", "<C-w>j")
keymap.set("n", "ml", "<C-w>l")

-- Diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)
