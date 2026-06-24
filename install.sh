#!/usr/bin/env bash
# raohdev dotfiles bootstrap.
# Safe to re-run. Installs deps via Homebrew, links configs via GNU Stow,
# and clones tmux plugins.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_TARGET="$HOME"
STOW_PACKAGES=(zsh nvim ghostty aerospace sketchybar starship nushell tmux yabai gh-dash flashspace)

info()  { printf "\033[1;34m==>\033[0m %s\n" "$*"; }
warn()  { printf "\033[1;33m!!\033[0m %s\n" "$*"; }
ok()    { printf "\033[1;32mok\033[0m %s\n" "$*"; }

# ---------------------------------------------------------------------------
# 1. Homebrew
# ---------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # shellcheck disable=SC1091
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  ok "Homebrew present"
fi

# ---------------------------------------------------------------------------
# 2. Bundle (formulas, casks, taps)
# ---------------------------------------------------------------------------
info "Installing from Brewfile..."
brew bundle install --file "$REPO_DIR/Brewfile" || warn "Some bundle entries failed; continuing."

# ---------------------------------------------------------------------------
# 3. Stow packages (-R restows: removes owned links then recreates).
#    stow -R also replaces pre-existing manual symlinks into ~/.raohdev,
#    so no separate migration step is needed. If a real (non-symlink) file
#    conflicts, stow will report it -- inspect and move it aside, then re-run.
# ---------------------------------------------------------------------------
info "Stowing packages: ${STOW_PACKAGES[*]}"
command -v stow >/dev/null 2>&1 || { warn "stow not found; ensure Homebrew bin is on PATH and re-run."; exit 1; }
stow -R --target "$STOW_TARGET" --dir "$REPO_DIR" "${STOW_PACKAGES[@]}"
ok "packages stowed"

# ---------------------------------------------------------------------------
# 4. tmux plugins (loaded directly by tmux.conf, no TPM)
# ---------------------------------------------------------------------------
PLUGINS_DIR="$HOME/.config/tmux/plugins"
mkdir -p "$PLUGINS_DIR"
# name::url pairs
TMUX_PLUGINS=(
  "tmux::https://github.com/catppuccin/tmux"
  "catppuccin-tmux::https://github.com/omerxx/catppuccin-tmux"
  "tmux-sensible::https://github.com/tmux-plugins/tmux-sensible"
  "tmux-yank::https://github.com/tmux-plugins/tmux-yank"
  "tmux-resurrect::https://github.com/tmux-plugins/tmux-resurrect"
  "tmux-thumbs::https://github.com/fcsonline/tmux-thumbs"
  "tmux-fzf::https://github.com/sainnhe/tmux-fzf"
  "tmux-fzf-url::https://github.com/wfxr/tmux-fzf-url"
  "tmux-battery::https://github.com/tmux-plugins/tmux-battery"
  "tmux-continuum::https://github.com/tmux-plugins/tmux-continuum"
  "tmux-cpu::https://github.com/tmux-plugins/tmux-cpu"
  "tmux-net-speed::https://github.com/tmux-plugins/tmux-net-speed"
  "tmux-sessionx::https://github.com/omerxx/tmux-sessionx"
  "tmux-weather::https://github.com/xamut/tmux-weather"
  "tpm::https://github.com/tmux-plugins/tpm"
)
info "Ensuring tmux plugins..."
for entry in "${TMUX_PLUGINS[@]}"; do
  name="${entry%%::*}"
  url="${entry#*::}"
  if [ ! -d "$PLUGINS_DIR/$name/.git" ]; then
    git clone --depth 1 "$url" "$PLUGINS_DIR/$name" 2>/dev/null && ok "cloned $name" || warn "failed to clone $name"
  fi
done

# ---------------------------------------------------------------------------
# 5. Done
# ---------------------------------------------------------------------------
info "Bootstrap complete."
echo "  - Restart your shell or run: exec \$SHELL"
echo "  - Open nvim to auto-install plugins (vim.pack)."
echo "  - Start tmux to load the config."
