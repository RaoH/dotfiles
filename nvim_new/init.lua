-- Tab setup
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "

-- LazyVim packet manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' }
    },
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"}
}

local opts = {}


-- Loading lazy
require("lazy").setup(plugins, opts)

-- Telescop setup
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- THEME Setup
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

-- Treesitter config
local treesitter_conf = require("nvim-treesitter.configs")
treesitter_conf.setup({
	ensure_installed = {"lua", "elixir", "javascript", "html"},
	highlight = { enable = true },
    indent = { enable = true },
})


