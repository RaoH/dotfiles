export LANG=en_US.UTF-8
export TERM="xterm-256color"
[[ -n $TMUX ]] && export TERM="screen-256color"

# Prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

# Node version manager
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"

# Atuin shell history
command -v atuin >/dev/null && eval "$(atuin init zsh)"

# zsh autosuggestions
_zsh_autosuggestions="$(brew --prefix 2>/dev/null)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -s "$_zsh_autosuggestions" ] && source "$_zsh_autosuggestions"
unset _zsh_autosuggestions

# bun completions
_bun_comp="$(brew --prefix bun 2>/dev/null)/share/zsh/site-functions/_bun"
[ -s "$_bun_comp" ] && source "$_bun_comp"
unset _bun_comp

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Extra PATH entries
export PATH="/opt/homebrew/opt/redis@6.2/bin:/opt/podman/bin/podman:$PATH"
PATH="$HOME/.bin:$PATH"

# Cursor setup
echo -ne "\e[2 q"

# Aliases
alias vim=nvim
alias n=nvim
alias cat="bat"
alias ls="eza"
alias ltt='eza --tree --level=2 --long --icons --git'
alias ai="ollama run codellama"
alias ssh='TERM=xterm-256color ssh'
alias chrome-debug="_chrome_debug"
alias v="fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim"

function _chrome_debug() {
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    --user-data-dir=/tmp/chrome-debug/remote-kollarna_debug \
    --remote-debugging-port=9222 "$1" > /dev/null 2>&1 & disown
}

# Theme settings (unused with starship but kept for reference)
SPACESHIP_TIME_SHOW=true
SPACESHIP_HOST_SHOW="always"
