# AGENTS.md - Neovim Configuration

This is a Neovim 0.12+ configuration written in Lua. It uses the native `vim.pack`
plugin manager and the new native LSP configuration system via the `lsp/` directory.

## Project Structure

```
nvim.0.12/
├── init.lua              # Entry point - loads all modules
├── lsp/                  # LSP server configurations (native vim.lsp.config)
│   ├── lua_ls.lua        # Lua language server
│   ├── vtsls.lua         # TypeScript/JavaScript
│   ├── eslint.lua        # ESLint
│   ├── svelte.lua        # Svelte
│   ├── tailwindcss.lua   # Tailwind CSS
│   └── ...               # Other language servers
├── lua/
│   ├── config/           # Core configuration
│   │   ├── options.lua   # Vim options
│   │   ├── autocmds.lua  # Autocommands
│   │   ├── lsp_config.lua # LSP enable + diagnostics
│   │   └── ...
│   ├── plugins/          # Plugin configurations
│   │   ├── blink.lua     # Completion
│   │   ├── conform.lua   # Formatting
│   │   ├── which-key.lua # Keybindings
│   │   └── ...
│   └── ui/               # UI utilities
└── nvim-pack-lock.json   # Plugin lock file
```

## Formatting and Linting

### Formatters (via conform.nvim)

Format on save is enabled. Manual format: `<leader>cf`

| File Type | Formatter |
|-----------|-----------|
| Lua | `stylua` |
| JS/TS/JSX/TSX | `prettier` |
| Svelte | `prettier` |
| CSS/HTML | `prettier` |
| JSON/YAML | `prettier` |
| Markdown | `prettier` |
| HTTP | `kulala-fmt` |

### Lua Style Guidelines

- Use `stylua` for formatting (install via Mason)
- Tabs for indentation (configured by stylua defaults)
- No trailing whitespace
- Single quotes preferred for strings in table keys

### Linters

Managed via Mason:
- `selene` or `luacheck` for Lua
- `eslint` for JavaScript/TypeScript
- `shellcheck` for shell scripts

## Code Patterns

### Plugin Configuration Pattern

Plugins use `vim.pack.add()` followed by `require().setup()`:

```lua
-- Single plugin
vim.pack.add({ "https://github.com/author/plugin.nvim" })
require("plugin").setup({
    option = value,
})

-- Multiple related plugins
vim.pack.add({
    { src = "https://github.com/author/plugin1" },
    { src = "https://github.com/author/plugin2" },
})
```

### LSP Configuration Pattern (Neovim 0.12+)

LSP configs go in the `lsp/` directory and return a `vim.lsp.Config` table:

```lua
-- lsp/example_ls.lua
---@type vim.lsp.Config
return {
    cmd = { "example-language-server", "--stdio" },
    filetypes = { "example" },
    root_markers = { ".git", "config.json" },
    settings = {
        -- LSP-specific settings
    },
}
```

Enable LSPs in `lua/config/lsp_config.lua`:

```lua
vim.lsp.enable({
    "example_ls",
    -- other servers...
})
```

### Autocommand Pattern

```lua
vim.api.nvim_create_autocmd("EventName", {
    pattern = { "*.lua" },
    callback = function()
        -- handler code
    end,
})
```

### Keybinding Pattern (via which-key)

```lua
local wk = require("which-key")
wk.add({
    { "<leader>x", group = "group name" },
    {
        "<leader>xa",
        function()
            -- action
        end,
        desc = "Action description",
    },
    { "<leader>xb", "<cmd>Command<cr>", desc = "Command description" },
})
```

## Key Conventions

### Leader Keys
- Leader: `<Space>`
- Local leader: `\`

### Naming Conventions
- File names: lowercase with hyphens (e.g., `project-indent.lua`)
- Plugin files: match plugin name (e.g., `snacks.lua` for snacks.nvim)
- LSP files: match server name (e.g., `lua_ls.lua`, `vtsls.lua`)

### Import Style
- Use `require()` for Lua modules
- Prefer local variables for frequently used modules:
  ```lua
  local opt = vim.opt
  local wk = require("which-key")
  ```

### Type Annotations
- Use LuaLS annotations where helpful:
  ```lua
  ---@type vim.lsp.Config
  ---@param bufnr number
  ---@return string?
  ```

### Global Variables
- `vim` - Neovim API (always available)
- `Snacks` - snacks.nvim global (defined in `.luarc.json`)

### Error Handling
- Use `pcall` for operations that may fail:
  ```lua
  local ok = pcall(vim.cmd, "TSUpdate")
  if not ok then
      vim.notify("TSUpdate failed!", vim.log.levels.WARN)
  end
  ```

## Testing Changes

There are no automated tests. To test configuration changes:

1. Save the file (auto-formats on save)
2. Restart Neovim: `:qa` then reopen, or source the file: `:source %`
3. Check for errors: `:messages` or notification history `<leader>nh`
4. Verify LSP status: `:checkhealth lsp`

## Key Plugins Reference

| Plugin | Purpose | Key Bindings |
|--------|---------|--------------|
| snacks.nvim | Picker, notifications, dashboard | `<leader>ff`, `<leader>/` |
| which-key | Keybinding hints | Shows on leader press |
| conform.nvim | Formatting | `<leader>cf` |
| oil.nvim | File explorer | `<leader>fe` |
| gitsigns.nvim | Git signs | `<leader>g*` |
| blink.cmp | Completion | Auto-triggers |
| opencode.nvim | AI assistance | `<leader>co*` |
| nvim-dap | Debugging (DAP) | `<leader>d*` |

## Debugging (DAP)

Debug Adapter Protocol support for Node.js, TypeScript, and SvelteKit projects.
Uses `nvim-dap-view` for a minimal, unified debug UI.

### Prerequisites

- `js-debug-adapter` installed via Mason (auto-installed)
- Chrome/Chromium for client-side debugging

### Debug Keybindings

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue/Start debugging |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dt` | Toggle DAP UI |
| `<leader>dr` | Restart session |
| `<leader>dq` | Terminate session |
| `<leader>dl` | Run last configuration |
| `<leader>dh` | Hover variables |
| `<leader>dp` | Preview |
| `<leader>dv` | Toggle virtual text |
| `<leader>dw` | Add watch (pre-debug) |

### Virtual Text

Variable values are displayed inline in your code while debugging using `nvim-dap-virtual-text`.
Values appear with comment syntax (e.g., `// email = "user@example.com"`) and are shown at
all variable references. Changed variables are highlighted differently.

- Toggle with `<leader>dv` or `:DapVirtualTextToggle`
- Exception info shown when debugger stops on error

### Pre-Debug Watches

You can queue watch expressions **before** starting a debug session:

- `<leader>dw` or `:DapAddWatch <expr>` - Queue a watch expression
- Queued watches are automatically added when the debugger first stops
- Useful for setting up watches before hitting your first breakpoint

Example workflow:
1. `<leader>dw` → Enter `user.email`
2. `<leader>dw` → Enter `response.status`
3. `<leader>dc` → Start debugging
4. When debugger stops, watches are automatically added

### DAP View Sections

When the DAP view is open, switch sections using the winbar keys:

| Key | Section |
|-----|---------|
| `W` | Watches - Add and evaluate expressions |
| `S` | Scopes - View local/global variables |
| `E` | Exceptions - Configure exception breakpoints |
| `B` | Breakpoints - Manage all breakpoints |
| `T` | Threads - Navigate call stack |
| `R` | REPL - Interactive debug console |
| `g?` | Show section-specific keymaps |

**Note:** The terminal/console window is hidden for `pwa-node` and `pwa-chrome` adapters
since attach requests use an external process (your terminal running the dev server).

### Debug Configurations

1. **Attach to Node (--inspect)** - Attach to a running Node process
2. **Launch Current File (Node)** - Run current file in Node debugger
3. **Launch Chrome (Client)** - Launch Chrome for client-side debugging
4. **Attach to Chrome** - Attach to existing Chrome with remote debugging

### Server-Side SvelteKit Debugging

Debug `+page.server.ts`, `+server.ts`, `hooks.server.ts`, and other server code:

```bash
# Start dev server with inspect flag
npm --node-options='--inspect' run dev
```

Then in Neovim:
1. Open a server-side file
2. `<leader>db` to set breakpoint
3. `<leader>dc` → Select "Attach to Node (--inspect)"
4. Pick the Node process from the list
5. Trigger the code path (refresh page, make request)

### Client-Side SvelteKit Debugging

Debug `.svelte` component client-side code:

```bash
# Start dev server normally
npm run dev
```

Then in Neovim:
1. Open a `.svelte` component
2. `<leader>db` to set breakpoint in client code
3. `<leader>dc` → Select "Launch Chrome (Client)"
4. Chrome opens at localhost:5173
5. Interact with the page to trigger breakpoint

### Troubleshooting

**Breakpoints not hitting:**
- Ensure source maps are generated (default in SvelteKit)
- Check the process is running with `--inspect` for server-side
- Verify the correct debug configuration is selected

**Chrome not launching:**
- Ensure Chrome/Chromium is installed
- Check no other Chrome instance uses port 9222

**Process picker empty:**
- Start the dev server with `--inspect` flag first
- Try `npm --node-options='--inspect-brk' run dev` for short-lived scripts

## Common Tasks

### Adding a New Plugin

1. Create `lua/plugins/pluginname.lua`
2. Add `vim.pack.add({ "https://github.com/author/plugin" })`
3. Add `require("plugin").setup({ ... })`
4. Add `require("plugins.pluginname")` to `init.lua`

### Adding a New LSP

1. Create `lsp/server_name.lua` returning `vim.lsp.Config`
2. Add server name to `vim.lsp.enable()` in `lua/config/lsp_config.lua`
3. Ensure the server is installed via Mason or system package manager
