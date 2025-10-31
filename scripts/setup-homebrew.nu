#!/usr/bin/env nu

# Homebrew Setup Script
# Installs all packages and applications from your current Homebrew setup

def main [] {
    print "🍺 Setting up Homebrew packages..."
    
    # Check if Homebrew is installed
    if not (which brew | is-not-empty) {
        print "❌ Homebrew not found. Installing Homebrew first..."
        ^/bin/bash -c (curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
    } else {
        print "✅ Homebrew found"
    }
    
    # Update Homebrew
    print "🔄 Updating Homebrew..."
    brew update
    
    # Install formulae (CLI tools and libraries)
    let formulae = [
        "atac" "atuin" "bat" "bob" "borders" "btop" "bun" "cbonsai" 
        "cmake" "cmatrix" "cowsay" "erlang" "eza" "fd" "fnm" 
        "fzf" "gh" "gleam" "htop" "jq" "k9s" "kubernetes-cli" "lazygit" 
        "llvm" "lua" "luajit" "luarocks" "navi" "neovim" "nushell" "nvm" 
        "ollama" "opencode" "platformio" "pngpaste" "pnpm" "podman" 
        "ripgrep" "rust" "sketchybar" "starship" "tmux" 
        "tree-sitter" "yazi" "yarn" "z3" "zoxide" "zsh-autosuggestions"
    ]
    
    print $"📦 Installing ($formulae | length) formulae..."
    
    for formula in $formulae {
        try {
            print $"  Installing ($formula)..."
            brew install $formula
            print $"  ✅ ($formula) installed"
        } catch {
            print $"  ⚠️  Failed to install ($formula), skipping..."
        }
    }
    
    # Install casks (GUI applications)
    let casks = [
        "1password-cli" "aerospace" "font-cousine-nerd-font" "font-hack-nerd-font" 
        "font-jetbrains-mono-nerd-font" "font-sf-pro" "font-sketchybar-app-font" 
        "ghostty" "legcord" "mouseless@preview"
    ]
    
    print $"🖥️  Installing ($casks | length) casks..."
    
    for cask in $casks {
        try {
            print $"  Installing ($cask)..."
            brew install --cask $cask
            print $"  ✅ ($cask) installed"
        } catch {
            print $"  ⚠️  Failed to install ($cask), skipping..."
        }
    }
    
    # Cleanup
    print "🧹 Cleaning up..."
    brew cleanup
    
    print "🎉 Homebrew setup complete!"
    print "📊 Final status:"
    print $"  Formulae: ($formulae | length) packages"
    print $"  Casks: ($casks | length) applications"
}
