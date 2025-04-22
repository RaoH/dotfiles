$env.PNPM_HOME = '/Users/raoul/Library/pnpm'
$env.config.show_banner = false
$env.config.buffer_editor = 'nvim'
$env.STARSHIP_CONFIG = "/Users/raoul/.config/starship/starship.toml";

#VI mode
$env.config = {
	edit_mode: 'vi' 
}

use std "path add"
path add "/opt/homebrew/bin/"
path add "/Users/raoul/.local/bin"
path add "/Users/raoul/Library/pnpm"
path add "/opt/homebrew/opt/redis@6.2/bin"
path add "/opt/podman/bin"

# Update paths
let $fnm_all_vars = fnm env --shell bash | str  replace -a "export " '' | str replace -a '"' '' |  lines | split column "=" | rename name value | reduce -f {} {|it, acc| $acc | upsert $it.name $it.value };

let $fnm_path: string = $fnm_all_vars.PATH | str replace ":$PATH" ""
#print "Adding FNM to path: " $fnm_path
$env.PATH = $env.PATH | append $fnm_path;

# Add env vars
let $fnm_vars = $fnm_all_vars | reject PATH;
#print "Adding FNM vars to shell env: " $fnm_vars
load-env $fnm_vars


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

zoxide init nushell | save -f ~/.zoxide.nu
