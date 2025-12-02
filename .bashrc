PS1="\[\e[0;32m\]\w\[\e[0m\] \[\e[0;97m\] 
\$ \[\e[0m\]"
HISTSIZE=10000
HISTFILESIZE=1000000
shopt -s histappend
shopt -s autocd # Change directory

# On every prompt: append, clear in‑memory history, reload from file
PROMPT_COMMAND="history -a; history -c; history -r${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

export PATH=/data/data/com.termux/files/home/bin:/data/data/com.termux/files/usr/bin:~/.local/bin
export PATH="$PATH:~/p/bash"
export PATH="$PATH:/data/data/com.termux/files/home/.cargo/bin"
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=w3m

alias la='ls -la'
alias ll='ls -lah'
alias ..='cd ..'     # Move up one directory[web:22]
alias ...='cd ../..' # Move up two directories[web:22]
alias c='clear'      # Clear terminal screen[web:25]
alias h='history'    # Show command history[web:25]
alias df='df -h'     # Human readable disk usage[web:22]
alias mkd='mkdir -p' # Human readable disk usage[web:22]

alias ee='emacs'
alias e='eza'
alias et='eza --tree'
alias elt='eza --tree'
alias elt2='eza --tree --level=2'
alias el='eza -lh'
alias r='source ~/.bashrc'
alias b='nvim ~/.bashrc'
alias sb='emacs ~/.sbclrc'
alias cx='chmod +x'
alias pg='pgrep'
alias pu='pkg update'
alias puu='pkg upgrade'
alias pi='pkg install'
alias pis='pkg search'
alias py='python'
alias n='nvim'
#alias nl='cd ~/.config/nvim/; nvim init.el'
alias ng="n ~/General"
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push origin HEAD'
alias gpr='git pull --rebase'
alias gcm='git commit -m'
alias gst='git status'
alias gco='git checkout'

alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'
alias pls='sudo !!'
alias df='df -h'
alias topc='top -o %CPU'
alias psg='ps aux | grep -v grep | grep -i -E'
alias sbcl='rlwrap sbcl'
alias rkt='racket'
alias xo='xdg-open'
alias to='termux-open'
alias to='termux-open-url'

nvc() {
  cd ~/.config/nvim || return
  nvim init.lua
}

eval "$(zoxide init bash)"
#export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} | head -100'"bind '"C-f": " C-a fzf "'  # Example mapping Ctrl-F to launch fzf
PATH=$PATH:/data/data/com.termux/files/home/.local/bin
eval $(~/.local/bin/mise activate)
