# config.nu
#
# Installed by:
# version = "0.103.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

use std "path add"
path add "/opt/homebrew/bin/"

#$env.EDITOR = nvim
$env.config.buffer_editor = 'nvim'

#VI mode
$env.config = {
	edit_mode: 'vi' 
}

alias vim = nvim
#alias chrome-debug="_chrome_debug"
alias v = fd --type f --hidden --exclude .git | fzf #-p -- --reverse | xargs nvim
alias ls = eza
alias cat = bat
alias ai = ollama run codellama
alias lt = eza --tree --level=2 --long --icons --git
alias n = nvim


mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

zoxide init nushell | save -f ~/.zoxide.nu
