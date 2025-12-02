# bashrc for Termux on Android
# https://github.com/vukini/bashrc-termux

# =====================
# Environment Variables
# =====================

# Set default editor
export EDITOR='nano'
export VISUAL='nano'

# Set terminal type
export TERM='xterm-256color'

# Set locale (if available)
export LANG='en_US.UTF-8'

# History settings
export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTCONTROL=ignoreboth:erasedups

# =====================
# Shell Options
# =====================

# Append to history instead of overwriting
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize

# Enable extended globbing
shopt -s extglob

# Case-insensitive globbing
shopt -s nocaseglob

# Autocorrect typos in cd command
shopt -s cdspell

# =====================
# Prompt Customization
# =====================

# Colors for prompt
RESET='\[\033[0m\]'
GREEN='\[\033[0;32m\]'
BLUE='\[\033[0;34m\]'
CYAN='\[\033[0;36m\]'
YELLOW='\[\033[0;33m\]'

# Custom prompt: user@termux:directory$
PS1="${GREEN}\u${RESET}@${CYAN}termux${RESET}:${BLUE}\w${RESET}\$ "

# =====================
# Aliases
# =====================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List files
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Safety features
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Termux-specific aliases
alias pkgs='pkg list-installed'
alias update='pkg update && pkg upgrade'
alias install='pkg install'
alias search='pkg search'
alias uninstall='pkg uninstall'

# Storage shortcut
alias storage='termux-setup-storage'
alias sdcard='cd /sdcard'
alias downloads='cd /sdcard/Download'

# Clear screen
alias c='clear'
alias cls='clear'

# Show disk usage
alias df='df -h'
alias du='du -h'

# Network
alias myip='curl -s ifconfig.me'
alias ping='ping -c 5'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'

# =====================
# Functions
# =====================

# Create directory and cd into it
mkcd() {
    [ -z "$1" ] && { echo "Usage: mkcd <directory>"; return 1; }
    mkdir -p "$1" && cd "$1"
}

# Extract various archive types
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar x "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick backup of a file
backup() {
    [ ! -f "$1" ] && { echo "File '$1' not found"; return 1; }
    cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

# Show PATH in readable format
path() {
    echo "$PATH" | tr ':' '\n'
}

# =====================
# Termux-specific Setup
# =====================

# Enable programmable completion if available
if [ -f "$PREFIX/etc/bash_completion" ]; then
    . "$PREFIX/etc/bash_completion"
fi

# Welcome message (only for interactive shells)
if [[ $- == *i* ]]; then
    echo "Welcome to Termux!"
    echo "Type 'update' to update packages."
fi
