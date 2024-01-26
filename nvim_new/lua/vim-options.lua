-- Tab setup

require("config.autocmds")
require("config.keymaps")
require("config.options")

vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set relativenumber")
vim.cmd("set nu rnu")
vim.cmd("set signcolumn=yes:1")
-- vim.cmd("set numberwidth=2")
vim.g.mapleader = " "
