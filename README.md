# raohdev dotfiles

Personal macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each tool lives in its own Stow package; `install.sh` installs dependencies via
[Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) and links everything
into `$HOME`.

## One-line setup on a new machine

```sh
~/<checkout_dir>/install.sh
```

`install.sh` is idempotent — safe to re-run any time. It will:

1. Install Homebrew if missing.
2. `brew bundle install` everything in `Brewfile` (formulas, casks, taps, npm globals).
3. `stow -R` every package, symlinking configs into `$HOME`.
4. Clone the tmux plugins into `~/.config/tmux/plugins/`.

Then: `exec $SHELL`, open `nvim` (plugins auto-install via `vim.pack`), and start `tmux`.

## Layout

```
~/<checkout_dir>/
  install.sh           # bootstrap script
  Brewfile             # Homebrew bundle (regenerate: brew bundle dump --force)
  .gitignore
  zsh/        .zshrc
  nvim/       .config/nvim/         # Neovim 0.12+ (vim.pack + native LSP)
  tmux/       .config/tmux/         # tmux.conf + custom/ + plugins/ (gitignored)
  ghostty/    .config/ghostty/
  aerospace/  .config/aerospace/    # window manager (active)
  sketchybar/ .config/sketchybar/   # status bar
  starship/   .config/starship.toml
  nushell/    .config/nushell/
  gh-dash/    .config/gh-dash/
  flashspace/ .config/flashspace/   # workspace manager
  yabai/      .yabairc .skhdrc      # retired WM, kept for reference
  scripts/    test-font.sh, archive/
  docs/       cheatsheets, yabai.md
```

Stow maps each package's contents relative to `$HOME`, so `nvim/.config/nvim/init.lua`
becomes `~/.config/nvim/init.lua`.

## Adding a new app config

```sh
mkdir -p myapp/.config/myapp
$EDITOR myapp/.config/myapp/config.toml
stow -R --target ~ --dir ~/<checkout_dir> myapp
```

Then add `myapp` to `STOW_PACKAGES` in `install.sh` and commit.

## Updating the Brewfile

After installing/removing something with Homebrew:

```sh
brew bundle dump --force --file Brewfile
```

## Uninstalling a package's links

```sh
stow -D --target ~ --dir ~/<checkout_dir> <package>
```

## Notes

- `tmux/.config/tmux/plugins/` and `**/lazy-lock.json` are gitignored — plugins are
  cloned by `install.sh` (tmux) or auto-managed at runtime (nvim).
- `.zshrc` guards all optional tools (`starship`, `fnm`, `atuin`, `zsh-autosuggestions`)
  with `command -v`, so a half-installed machine still boots a usable shell.
- No hardcoded `/Users/...` paths remain — `$HOME` is used throughout.
