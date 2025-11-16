# AeroSpace Cheatsheet

## Window Navigation
| Key | Action |
|-----|---------|
| `⌥ H` | Focus left |
| `⌥ J` | Focus down |
| `⌥ K` | Focus up |
| `⌥ L` | Focus right |

## Window Movement
| Key | Action |
|-----|---------|
| `⌥ ⇧ H` | Move window left |
| `⌥ ⇧ J` | Move window down |
| `⌥ ⇧ K` | Move window up |
| `⌥ ⇧ L` | Move window right |

## Window Resizing
| Key | Action |
|-----|---------|
| `⌥ ⇧ -` | Resize smaller (-50) |
| `⌥ ⇧ =` | Resize larger (+50) |

## Layout Control
| Key | Action |
|-----|---------|
| `⌥ /` | Toggle tiles layout (horizontal/vertical) |
| `⌥ ,` | Toggle accordion layout (horizontal/vertical) |

### Creating Complex Layouts

**Example: Horizontal main split with vertical sub-split**
```
┌─────────────┬─────────────┐
│             │    Window   │
│   Window    │      3      │
│     1       ├─────────────┤
│             │    Window   │
│             │      4      │
└─────────────┴─────────────┘
```

**Steps to create:**
1. Open Window 1 & 2 (auto-splits horizontally)
2. `⌥ L` (focus right window)
3. `⌥ /` (toggle right container to vertical)
4. Open Window 3 & 4 (splits vertically in right container)

**Key insight:** AeroSpace uses nested containers. `⌥ /` changes the focused container's orientation, affecting how new windows split within that container.

## Workspace Navigation
| Key | Workspace |
|-----|-----------|
| `⌥ 1-9` | Switch to workspace 1-9 |
| `⌥ 0` | Switch to workspace 0 |
| `⌥ Tab` | Switch to previous workspace |

## Move Window to Workspace
| Key | Action |
|-----|---------|
| `⌥ ⇧ 1-9` | Move window to workspace 1-9 |
| `⌥ ⇧ 0` | Move window to workspace 0 |

## Monitor Management
| Key | Action |
|-----|---------|
| `⌥ ⇧ Tab` | Move workspace to next monitor |

## Service Mode (`⌥ ⇧ ;`)
| Key | Action |
|-----|---------|
| `Esc` | Reload config & exit service mode |
| `R` | Reset layout & exit service mode |
| `F` | Toggle floating/tiling & exit service mode |
| `⌫` | Close all windows except current & exit service mode |
| `⌥ ⇧ H/J/K/L` | Join window with direction & exit service mode |
| `⌥ ⇧ G` | Toggle fullscreen |

## Auto-assigned Apps
| App | Workspace |
|-----|-----------|
| ForkLift/Finder | 2 |
| Discord/Messages | 6 |
| Mail/Calendar | 7 |
| Ghostty (Terminal) | 8 |
| Obsidian | 9 |

## Configuration
- **Layout**: Auto-orientation (wide=horizontal, tall=vertical)
- **Gaps**: 20px inner, 5px outer (38px top for external monitors)
- **Accordion padding**: 35px
- **Integrations**: Sketchybar + Borders auto-start