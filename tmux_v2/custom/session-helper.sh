#!/usr/bin/env bash
#
# Helper script for session-switcher.sh
# Handles switch/create actions from fzf
#
# Usage: session-helper.sh <action> <query> <selection>
#   action: switch-or-create
#   query: what user typed in fzf
#   selection: what was selected (may be empty)

set -euo pipefail

action="${1:-}"
query="${2:-}"
selection="${3:-}"

# Extract session name (first word) from selection if it contains extra info
if [[ -n "$selection" ]]; then
    selection=$(echo "$selection" | awk '{print $1}')
fi

# Use selection if available, otherwise use query
target="${selection:-$query}"

[[ -z "$target" ]] && exit 0

case "$action" in
    switch-or-create)
        # Check if it's an existing session
        if tmux has-session -t="$target" 2>/dev/null; then
            tmux switch-client -t "$target"
            exit 0
        fi
        
        # Check if it's a window (contains colon, e.g., "session:1 windowname")
        if [[ "$target" == *":"* ]]; then
            window_target="${target%% *}"  # Get "session:index" part
            tmux switch-client -t "$window_target"
            exit 0
        fi
        
        # Check if it's a directory path
        if [[ -d "$target" ]]; then
            session_name=$(basename "$target" | tr './ ' '___')
            if ! tmux has-session -t="$session_name" 2>/dev/null; then
                tmux new-session -ds "$session_name" -c "$target"
            fi
            tmux switch-client -t "$session_name"
            exit 0
        fi
        
        # Create new session with query as name (if no selection matched)
        if [[ -n "$query" ]] && ! tmux has-session -t="$query" 2>/dev/null; then
            tmux new-session -ds "$query"
            tmux switch-client -t "$query"
            exit 0
        fi
        
        # Fallback: try to switch to target
        tmux switch-client -t "$target" 2>/dev/null || true
        ;;
    
    # Legacy support
    switch)
        target="${query:-$selection}"
        [[ -z "$target" ]] && exit 0
        
        if tmux has-session -t="$target" 2>/dev/null; then
            tmux switch-client -t "$target"
        elif [[ -d "$target" ]]; then
            session_name=$(basename "$target" | tr './ ' '___')
            tmux new-session -ds "$session_name" -c "$target" 2>/dev/null || true
            tmux switch-client -t "$session_name"
        fi
        ;;
esac
