# Tmux Keybindings Cheatsheet

**Prefix Key:** `Ctrl+A`

## Session Management
| Key | Description |
|-----|-------------|
| `Ctrl+A` `o` | Open sessionx (fuzzy session switcher) |
| `Ctrl+A` `S` | Choose session from list |
| `Ctrl+A` `Ctrl+D` | Detach from current session |
| `Alt+f` | Toggle floating session (persistent popup) |

## Window Management
| Key | Description |
|-----|-------------|
| `Ctrl+A` `Ctrl+C` | Create new window (opens in $HOME) |
| `Ctrl+A` `c` | Kill current pane |
| `Ctrl+A` `H` | Go to previous window |
| `Ctrl+A` `L` | Go to next window |
| `Ctrl+A` `Ctrl+A` | Switch to last window |
| `Ctrl+A` `w` or `Ctrl+W` | List all windows |
| `Ctrl+A` `"` | Choose window from list |
| `Ctrl+A` `r` | Rename current window |
| `Ctrl+Shift+Left` | Move window left |
| `Ctrl+Shift+Right` | Move window right |

## Pane Management
| Key | Description |
|-----|-------------|
| `Ctrl+A` `s` | Split pane vertically (in current path) |
| `Ctrl+A` `v` | Split pane horizontally (in current path) |
| `Ctrl+A` `\|` | Split window |
| `Ctrl+A` `h` | Select pane left |
| `Ctrl+A` `j` | Select pane down |
| `Ctrl+A` `k` | Select pane up |
| `Ctrl+A` `l` | Select pane right |
| `Ctrl+A` `z` | Toggle pane zoom |
| `Ctrl+A` `x` | Swap pane down |
| `Ctrl+A` `!` | Break pane into hidden pane |
| `Ctrl+A` `@` | Join hidden pane back |
| `Ctrl+A` `P` | Toggle pane border status |
| `Ctrl+A` `*` | Toggle pane synchronization |

## Pane Resizing (Repeatable)
| Key | Description |
|-----|-------------|
| `Ctrl+A` `Ctrl+k` | Resize pane up (5 lines) |
| `Ctrl+A` `Ctrl+j` | Resize pane down (5 lines) |
| `Ctrl+A` `Ctrl+h` | Resize pane left (5 columns) |
| `Ctrl+A` `Ctrl+l` | Resize pane right (5 columns) |
| `Ctrl+A` `,` | Resize pane left (20 columns) |
| `Ctrl+A` `.` | Resize pane right (20 columns) |
| `Ctrl+A` `-` | Resize pane down (7 lines) |
| `Ctrl+A` `=` | Resize pane up (7 lines) |

## Popup Tools (Repeatable)
| Key | Description |
|-----|-------------|
| `Ctrl+A` `g` | Open lazygit in popup (80% size) |
| `Ctrl+A` `t` | Open btop in popup (80% size) |

## Plugins & Tools
| Key | Description |
|-----|-------------|
| `Ctrl+A` `Space` | tmux-thumbs (hint mode for text selection) |
| `Ctrl+A` `F` | tmux-fzf (fuzzy finder menu) |
| `Ctrl+A` `u` | tmux-fzf-url (find and open URLs) |
| `Ctrl+A` `y` | tmux-yank (copy to system clipboard) |

## Copy Mode (Vi-style)
| Key | Description |
|-----|-------------|
| `Ctrl+A` `[` | Enter copy mode |
| `v` | Begin selection (in copy mode) |
| `y` | Copy selection |
| `q` | Exit copy mode |

## System & Misc
| Key | Description |
|-----|-------------|
| `Ctrl+A` `R` | Reload tmux config |
| `Ctrl+A` `r` | Reload tmux config with message |
| `Ctrl+A` `:` | Enter command prompt |
| `Ctrl+A` `Ctrl+X` | Lock server |
| `Ctrl+A` `Ctrl+L` | Refresh client |
| `Ctrl+A` `*` | List all clients |
| `Ctrl+t` | Toggle status bar visibility |

## Notes
- Commands marked as "Repeatable" can be pressed multiple times without re-entering prefix
- Prefix is set to `Ctrl+A` instead of default `Ctrl+B`
- Vi-style key bindings enabled for copy mode
- All splits preserve current working directory
- Session restore enabled via tmux-continuum

## Configuration Files
- `tmux.conf` - Main configuration file
- `tmux.reset.conf` - Base keybinding definitions
