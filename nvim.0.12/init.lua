-- Vim options
require("config.autocmds")
require("config.options")
require("config.lsp_config")
--
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
--
-- -- Project-specific indent detection
require("config.project-indent")

--
-- -- PLUGINS
require("plugins.blink")
require("plugins.catppuccin")
require("plugins.coding")
require("plugins.conform")
require("plugins.fidget")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.mason")
require("plugins.mini")
require("plugins.outline")
require("plugins.opencode")
require("plugins.oil")
require("plugins.snacks")
require("plugins.treesitter")
require("plugins.ui")
require("plugins.which-key")
