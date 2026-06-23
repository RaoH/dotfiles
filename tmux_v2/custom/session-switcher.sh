#!/usr/bin/env bash
#
# Fast tmux session switcher
# Uses display-popup with pre-fetched data for minimal latency
#
# Keybindings:
#   enter    = switch to session/window or create from path
#   ctrl-d   = kill session
#   ctrl-r   = rename session
#   ctrl-w   = window mode
#   ctrl-p   = projects mode (~/$PROJECTS_DIR)
#   ctrl-z   = zoxide mode
#   ctrl-o   = opencode sessions
#   ctrl-n   = claude sessions
#   ctrl-b   = back to sessions
#   esc      = quit

CURRENT=$(tmux display-message -p '#S')
PROJECTS_DIR="$HOME/projects"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPER="$SCRIPT_DIR/session-helper.sh"

# Pre-fetch session list (faster than piping through fzf)
SESSIONS=$(tmux list-sessions -F '#{session_name}|#{session_path}|#{session_windows}w' | \
    grep -v "^${CURRENT}|" | \
    grep -v '^opencode' | \
    grep -v '^claude-' | \
    column -t -s'|')

# Run fzf with pre-fetched data
echo "$SESSIONS" | fzf \
    --prompt=' ' \
    --layout=default \
    --no-preview \
    --no-info \
    --highlight-line \
    --border=rounded \
    --border-label=' Sessions ' \
    --border-label-pos=0 \
    --input-border=rounded \
    --input-label=' C-d:kill  C-r:rename  C-w:windows  C-p:projects  C-z:zoxide  C-o:opencode  C-n:claude ─╮' \
    --input-label-pos=-1 \
    --list-border=rounded \
    --padding=1 \
    --margin=0 \
    --color=bg+:#363a4f,fg+:#cad3f5,pointer:#c6a0f6,prompt:#c6a0f6,border:#8087a2,label:#cad3f5,input-border:#eed49f,list-border:#8087a2,header:#6e738d,input-label:#eed49f,gutter:-1 \
    --pointer='▌' \
    --print-query \
    --with-nth=1.. \
    --bind="enter:become($HELPER switch-or-create {q} {1})" \
    --bind="ctrl-d:execute-silent(tmux kill-session -t {1})+reload(tmux list-sessions -F '#{session_name}|#{session_path}|#{session_windows}w' | grep -v '^${CURRENT}|' | grep -v '^opencode' | grep -v '^claude-' | column -t -s'|')" \
    --bind="ctrl-r:execute(printf 'New name: ' >&2; read name </dev/tty; tmux rename-session -t {1} \"\$name\")+reload(tmux list-sessions -F '#{session_name}|#{session_path}|#{session_windows}w' | grep -v '^${CURRENT}|' | grep -v '^opencode' | grep -v '^claude-' | column -t -s'|')" \
    --bind="ctrl-w:reload(tmux list-windows -a -F '#{session_name}:#{window_index} #{window_name}' | grep -v '^${CURRENT}:' | grep -v '^opencode' | grep -v '^claude-')+change-prompt(  )+change-border-label( Windows )+change-input-label( C-b:back ─╮)" \
    --bind="ctrl-p:reload(find '$PROJECTS_DIR' -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)+change-prompt(  )+change-border-label( Projects )+change-input-label( C-b:back ─╮)" \
    --bind="ctrl-z:reload(zoxide query -l 2>/dev/null | head -50)+change-prompt(  )+change-border-label( Zoxide )+change-input-label( C-b:back ─╮)" \
    --bind="ctrl-o:reload(tmux list-sessions -F '#{session_name}|#{session_path}|#{session_windows}w' | grep '^opencode' | column -t -s'|')+change-prompt(  )+change-border-label( Opencode )+change-input-label( C-d:kill  C-b:back ─╮)" \
    --bind="ctrl-n:reload(tmux list-sessions -F '#{session_name}|#{session_path}|#{session_windows}w' | grep '^claude-' | column -t -s'|')+change-prompt(  )+change-border-label( Claude )+change-input-label( C-d:kill  C-b:back ─╮)" \
    --bind="ctrl-b:reload(tmux list-sessions -F '#{session_name}|#{session_path}|#{session_windows}w' | grep -v '^${CURRENT}|' | grep -v '^opencode' | grep -v '^claude-' | column -t -s'|')+change-prompt(  )+change-border-label( Sessions )+change-input-label( C-d:kill  C-r:rename  C-w:windows  C-p:projects  C-z:zoxide  C-o:opencode  C-n:claude ─╮)" \
    --bind='esc:abort' \
    || true
