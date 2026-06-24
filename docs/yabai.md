# Yabai Setup (No SIP Required)

This is a yabai + skhd config that mirrors your Aerospace setup.

## Install

```bash
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
brew install jq  # needed for layout toggle
```

## Setup

```bash
# Create config directories
mkdir -p ~/.config/yabai
mkdir -p ~/.config/skhd

# Symlink configs
ln -sf ~/.dotfiles/yabai/yabairc ~/.config/yabai/yabairc
ln -sf ~/.dotfiles/yabai/skhdrc ~/.config/skhd/skhdrc

# Make yabairc executable
chmod +x ~/.config/yabai/yabairc
```

## Start Services

```bash
# Stop Aerospace first!
aerospace quit  # or killall AeroSpace

# Start yabai and skhd
yabai --start-service
skhd --start-service
```

## Stop/Switch Back to Aerospace

```bash
yabai --stop-service
skhd --stop-service

# Restart Aerospace
open -a AeroSpace
```

## Keybindings (same as Aerospace)

| Key | Action |
|-----|--------|
| alt + h/j/k/l | Focus window left/down/up/right |
| alt + shift + h/j/k/l | Swap window left/down/up/right |
| alt + 1-9 | Switch to workspace 1-9 |
| alt + shift + 1-9 | Move window to workspace 1-9 |
| alt + tab | Switch to recent workspace |
| alt + shift + tab | Move workspace to next monitor |
| alt + / | Toggle tile/stack layout |
| alt + shift + f | Toggle float |
| alt + shift + g | Toggle fullscreen |
| alt + shift + r | Balance/reset layout |
| alt + shift + - | Shrink window |
| alt + shift + = | Grow window |
| ctrl + alt + cmd + r | Restart yabai |

## Limitations Without SIP

- No smooth space switching animations (uses macOS default)
- No focus-follows-mouse (works but janky)
- No window borders (would need JankyBorders like with Aerospace)

## Sketchybar Integration

The config sends signals to sketchybar on space/focus changes. You'll need to update your sketchybar config to listen for:
- `yabai_space_changed` instead of `aerospace_workspace_change`
- `yabai_window_focused` for window focus events

## Troubleshooting

```bash
# Check if yabai is running
yabai -m query --spaces

# Check skhd
skhd -o  # shows which keys are being pressed

# View logs
tail -f /tmp/yabai_*.err.log
tail -f /tmp/skhd_*.err.log

# Restart
yabai --restart-service
skhd --restart-service
```
