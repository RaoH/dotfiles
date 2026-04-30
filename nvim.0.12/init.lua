-- Leader keys (must be set before any keybindings)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Vim options
require("config.autocmds")
require("config.options")

-- Load SchemaStore before LSP config (jsonls depends on it)
vim.cmd.packadd("SchemaStore.nvim")

require("config.lsp_config")
--
--
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
require("plugins.project")
require("plugins.treesitter")
require("plugins.ui")
require("plugins.ufo")
require("plugins.dap")
require("plugins.octo")
require("plugins.which-key")
require("plugins.dadbod")
