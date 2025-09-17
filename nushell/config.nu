$env.PNPM_HOME = '/Users/raoul/Library/pnpm'
$env.config.show_banner = false
$env.config.buffer_editor = 'nvim'
$env.STARSHIP_CONFIG = "/Users/raoul/.config/starship/starship.toml"
#$env.DOCKER_HOST = ^podman info | from yaml | $in.host.remoteSocket.path
$env.config.completions.algorithm = "Fuzzy"

#VI mode
$env.config = {
	edit_mode: 'vi' 
}

use std "path add"
path add "/opt/homebrew/bin/"
path add "/User/raoul/.local/share/bob"
path add "/opt/homebrew/sbin/"
path add "/Users/raoul/.local/bin"
path add "/Users/raoul/Library/pnpm"
path add "/Users/raoul/.docker"
path add "/opt/homebrew/opt/redis@6.2/bin"
path add "/opt/podman/bin"
path add "/usr/local/share/dotnet"

# Load aliass	
source /Users/raoul/.config/nushell/my-aliases.nu
#
##Load completions
source /Users/raoul/.config/nushell/completions/aerospace-completions.nu
source /Users/raoul/.config/nushell/completions/curl.nu
source /Users/raoul/.config/nushell/completions/op-completions.nu
source /Users/raoul/.config/nushell/completions/pnpm-completions.nu
#
## load modules
source /Users/raoul/.config/nushell/modules/docker/mod.nu
source /Users/raoul/.config/nushell/modules/fnm/fnm.nu

alias vim = nvim
#alias chrome-debug="_chrome_debug"
alias v = fd --type f --hidden --exclude .git | fzf #-p -- --reverse | xargs nvim
#alias ls = eza
alias cat = bat
alias ai = ollama run codellama
alias lt = eza --tree --level=2 --long --icons --git
alias n = nvim

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

zoxide init nushell | save -f /Users/raoul/.zoxide.nu
