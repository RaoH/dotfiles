#/bin/sh

brew install tmux lazygit ripgrep fd fzf exa jq fzf-bash-completion fzf-zsh-completion
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font
brew install nvim
brew install nvm

#infocmp > /tmp/${TERM}.ti
#Add Smulx=\E[4\:%p1%dm, after smul=\E[4m,
#tic -x /tmp/${TERM}.ti
#
#infocmp -l -x | grep Smulx
#        vpa=\E[%i%p1%dd, Smulx=\E[4\:%p1%dm,
