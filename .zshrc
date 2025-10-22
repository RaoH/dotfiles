export LANG=en_US.UTF-8

eval "$(starship init zsh)"


export TERM="xterm-256color"
export DOCKER_HOST=unix:///var/folders/s7/5yc_kfq10_7937dgr3xfcv600000gn/T/podman/podman-machine-default-api.sock
export CONTAINER_ENGINE_PODMAN=1

[[ -n $TMUX ]] && export TERM="screen-256color"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

#ZSH_THEME="spaceship"  #"steeef" #gnzh

#THEME SETTINGS:
SPACESHIP_TIME_SHOW=true
SPACESHIP_HOST_SHOW="always"

function _chrome_debug() { 
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --user-data-dir=/tmp/chrome-debug/remote-kollarna_debug --remote-debugging-port=9222 "$1" > /dev/null 2>&1 & disown; 
};

alias vim=nvim
alias chrome-debug="_chrome_debug"
alias v="fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim"
alias ls="eza"
alias cat="bat"
alias ai="ollama run codellama"
alias lt='eza --tree --level=2 --long --icons --git'
alias n=nvim

# Cursor setup
echo -ne "\e[2 q"

# bun completions
[ -s "/opt/homebrew/Cellar/bun/1.0.13/share/zsh/site-functions/_bun" ] && source "/opt/homebrew/Cellar/bun/1.0.13/share/zsh/site-functions/_bun"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# pnpm
export PNPM_HOME="/Users/raoul/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="/opt/homebrew/opt/redis@6.2/bin:/opt/podman/bin/podman:$PATH"
eval "$(atuin init zsh)"

PATH=~/.console-ninja/.bin:$PATH
