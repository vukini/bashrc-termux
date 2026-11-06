
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim
export VISUAL=nvim

# Prompt and history (from vukini/bashrc-termux): green path, then `$` on
# its own line so long paths don't crowd the command on a phone.
if [[ $- == *i* ]]; then
  PS1="\[\e[0;32m\]\w\[\e[0m\] \[\e[0;97m\]
\$ \[\e[0m\]"
  HISTSIZE=10000
  HISTFILESIZE=1000000
  shopt -s histappend
  shopt -s autocd
  # On every prompt: append, clear in-memory history, reload from file, so
  # all open sessions share one history. Guarded so a reload (alias `r`)
  # doesn't stack it.
  [[ $PROMPT_COMMAND == *"history -a"* ]] ||
    PROMPT_COMMAND="history -a; history -c; history -r${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
fi

# fzf: Ctrl-R fuzzy history, Ctrl-T file picker, Alt-C cd (interactive shells only)
if [[ $- == *i* ]] && command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
fi

# Aliases and functions carried over from my GitHub dotfiles
if [[ $- == *i* ]] && [ -r "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi

# Private aliases and functions (servers, hosts) live outside any repo.
[[ -r "$HOME/.bashrc.local" ]] && . "$HOME/.bashrc.local"

# Said on a reload (alias `r`) only, not in every new terminal.
[[ $- == *i* && ${_bashrc_loaded-} ]] && echo "Successfully sourced .bashrc"
_bashrc_loaded=1
