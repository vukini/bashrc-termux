# ~/.bash_aliases -- aliases and functions carried over from GitHub:
#   vukini/dotfiles       bash/.bashrc  (desktop, Void Linux)
#   vukini/bashrc-termux  .bashrc       (older Termux setup: the general names
#                                        the desktop gets from Vikix)
# Adapted for Termux: no sudo, pkg instead of xbps, termux-open instead of
# xdg-open. Desktop-only things (Vikix, runit, iPhone, Lazarus, StumpWM, ...)
# are left out. Where the two files disagree, dotfiles wins.
# Sourced from ~/.bashrc for interactive shells.

_have() { command -v "$1" >/dev/null 2>&1; }

# ---------------------------------------------------------------------- PATH
# Idempotent, so re-sourcing (alias `r`) doesn't grow PATH. Missing
# directories are skipped rather than added blindly.
add_path() {
    # add_path DIR [after]   -- prepends by default
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) return 0 ;;
    esac
    if [ "$2" = after ]; then
        PATH="$PATH:$1"
    else
        PATH="$1:$PATH"
    fi
}
add_path "$HOME/bin"        after
add_path "$HOME/.cargo/bin" after
export PATH

# ------------------------------------------------------------------- general
alias la='ls -la'
alias ll='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias cls='clear'
alias h='history'
alias df='df -h'
alias mkd='mkdir -p'
alias cx='chmod +x'
alias py='python'
alias r='source ~/.bashrc'

alias pg='pgrep'
alias psg='ps aux | grep -v grep | grep -i -E'
alias topc='top -o %CPU'
alias kk='kill -9'                      # desktop: sudo kill -9
alias pv='ping voidlinux.org'

# ------------------------------------------------------------------- editors
alias n='nvim'
alias nv='nvim'
alias nf='n $(fzf)'
alias b='nvim ~/.bashrc'
alias nvc='nvim ~/.config/nvim/init.lua'
alias lnv='nvim ~/.config/nvim'
nn() {
    cd "$HOME/.config/nvim" || return
    nvim "$HOME/.config/nvim/init.lua"
}
if _have emacs; then
    alias ee='emacs'
    alias eb='emacsclient -nw -a "" ~/.bashrc'   # -a "": start a daemon if none runs
fi

# ------------------------------------------------------------- listing (eza)
if _have eza; then
    alias e='eza'
    alias et='eza'
    alias el='eza -l'
    alias elt='eza --tree'
    alias elt2='eza --tree --level=2'
    alias lst='eza -l --tree --level=2'
    alias lstf='eza -l --tree'
fi

# ------------------------------------------------------------------ packages
# Same names as the desktop (xbps there, pkg here).
alias pi='pkg install'
alias pis='pkg search'
alias piu='pkg upgrade'
alias pu='pkg update'
alias puu='pkg upgrade'

# ---------------------------------------------------------------------- lisp
if _have sbcl; then
    alias sb='sbcl'
    _have rlwrap && alias sbcl='rlwrap sbcl'
fi

# ----------------------------------------------------------------------- git
alias gs='git status'
alias gst='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gcm='git commit -m'
alias gcl='git clone'
alias gp='git push origin HEAD'
alias gpr='git pull --rebase'
alias gco='git checkout'
alias gcheck='git checkout'
alias gfo='git fetch origin'
alias gsp='git stash; git pull'

# _gcatchup DIR: when GitHub has commits this repo doesn't (another
# machine or session pushed), put ours on top of them with a rebase.
# Refuses, changing nothing, when there are uncommitted changes, or when
# a commit not yet pushed carries a tag: a rebase gives it a new id and
# the tag would stay on the old one. A conflict is undone, so the repo is
# left as it was.
_gcatchup() {
  local r=$1 tagged new
  git -C "$r" fetch -q origin || { echo "   couldn't fetch from GitHub"; return 1; }
  new=$(git -C "$r" rev-list --count '..@{u}' 2>/dev/null || echo 0)
  [ "$new" -gt 0 ] || return 0   # nothing new there
  if [ -z "$(git -C "$r" log --oneline '@{u}..')" ]; then   # none of ours: a fast-forward, as a plain pull
    git -C "$r" merge -q --ff-only '@{u}' && echo "   caught up: $new new from GitHub"
    return
  fi
  if ! git -C "$r" diff --quiet || ! git -C "$r" diff --cached --quiet; then
    echo "   GitHub has new commits, and there are uncommitted changes: commit them, then try again"
    return 1
  fi
  tagged=$(git -C "$r" log --format=%H '@{u}..' | while read -r c; do git -C "$r" tag --points-at "$c"; done)
  if [ -n "$tagged" ]; then
    echo "   GitHub has new commits, and this release isn't pushed yet: $(echo $tagged)"
    echo "   ask a session to rebase it onto origin/main and move the tag"
    return 1
  fi
  if git -C "$r" rebase -q '@{u}' >/dev/null 2>&1; then
    echo "   caught up: $new new from GitHub, ours on top"
  else
    git -C "$r" rebase --abort 2>/dev/null
    echo "   GitHub's new commits clash with ours; left as it was. Ask a session to rebase and resolve it"
    return 1
  fi
}

# gpush [DIR...]: make sure these repos are on GitHub, commits and tags.
# Without DIRs, the repo you are in (the desktop defaults to the Vikix
# repos, which don't exist here). Uncommitted changes are only listed.
# When GitHub has moved on, it catches up first (_gcatchup) and pushes again.
gpush() {
  local r ok=0 missing
  [ $# -gt 0 ] || set -- .
  for r in "$@"; do
    echo "== ${r/#$HOME/\~}"
    git -C "$r" status --short | grep -v '^??' | sed 's/^/   not committed: /'
    # A new repo's first push: give the branch its upstream.
    git -C "$r" rev-parse -q --verify '@{u}' >/dev/null 2>&1 ||
      git -C "$r" push -q -u origin HEAD || { ok=1; continue; }
    git -C "$r" push --follow-tags -q 2>/dev/null ||
      { _gcatchup "$r" && git -C "$r" push --follow-tags -q; } || { ok=1; continue; }
    missing=$(comm -23 <(git -C "$r" tag | sort) \
      <(git -C "$r" ls-remote --tags origin | sed -n 's|.*refs/tags/\([^^]*\)$|\1|p' | sort))
    # shellcheck disable=SC2086  # one tag a word
    [ -z "$missing" ] || git -C "$r" push -q origin $missing || ok=1
    git -C "$r" fetch -q origin
    if [ -n "$(git -C "$r" log --oneline '@{u}..' 2>/dev/null)" ]; then
      echo "   still ahead of origin"; ok=1
    else
      echo "   pushed: $(git -C "$r" log -1 --format='%h %s' | cut -c1-60)"
    fi
  done
  return $ok
}

# gpl: pull, and when both sides have new commits, put ours on top
# (_gcatchup) instead of refusing.
unalias gpl 2>/dev/null
gpl() { echo "== ${PWD/#$HOME/\~}"; _gcatchup . && echo "   up to date: $(git log -1 --format='%h %s' | cut -c1-60)"; }

# ------------------------------------------------------------------- opening
# xo FILE...  open with the usual Android app (desktop: xdg-open).
unalias xo 2>/dev/null
xo() { termux-open "$@"; }
alias to='termux-open-url'

# --- Fuzzy finding (fzf, with fd, bat and rg) ---------------------------------
# Type a few letters to narrow, Enter picks, Esc leaves. Hidden files are in,
# .git isn't. Each takes an optional folder or starting query.
#   ff  [dir]    find a file, preview it; prints the path (cp "$(ff)" ...)
#   fo  [dir]    find a file and open it in its usual app (termux-open)
#   fe  [dir]    find a file and edit it in $EDITOR
#   fcd [dir]    find a folder and cd into it
#   fh           find a command in your history; Up then brings it back
#   frg PATTERN  find text in files (ripgrep); edit at that line
_fz_files() { fd --type f --hidden --exclude .git . "${1:-.}" 2>/dev/null; }
if _have bat; then
  _fz_preview='bat --style=numbers --color=always --line-range :300 {} 2>/dev/null'
else
  _fz_preview='head -n 300 {} 2>/dev/null'
fi
if _have eza; then
  _fz_dir_preview='eza -1 --color=always --group-directories-first {}'
else
  _fz_dir_preview='ls -1 {}'
fi

ff() {
  _fz_files "$1" | fzf --height 80% --reverse --prompt 'file> ' --preview "$_fz_preview"
}

fo() {
  local f; f=$(ff "$1") || return
  termux-open "$f"
}

fe() {
  local f; f=$(ff "$1") || return
  "${EDITOR:-nvim}" "$f"
}

fcd() {
  local d
  d=$(fd --type d --hidden --exclude .git . "${1:-.}" 2>/dev/null |
      fzf --height 80% --reverse --prompt 'cd> ' --preview "$_fz_dir_preview") || return
  cd "$d" || return
}

fh() {
  local c
  c=$(HISTTIMEFORMAT='' history | sed 's/^ *[0-9]* *//' | tac | awk '!seen[$0]++' |
      fzf --height 60% --reverse --prompt 'history> ' --no-sort) || return
  # Not run: it goes into your history, so Up brings it to the prompt
  # to check or change first.
  history -s "$c"
  printf '%s   (Up to use it)\n' "$c"
}

frg() {
  [ -n "$1" ] || { echo "frg PATTERN [dir]"; return 1; }
  local hit
  local -a prev=()
  _have bat && prev=(--preview 'bat --style=numbers --color=always --highlight-line {2} {1}' --preview-window '+{2}-/2')
  hit=$(rg --line-number --no-heading --color=always --hidden --glob '!.git' "$1" "${2:-.}" |
        fzf --ansi --height 80% --reverse --prompt 'text> ' --delimiter : "${prev[@]}") || return
  "${EDITOR:-nvim}" "+$(cut -d: -f2 <<<"$hit")" "$(cut -d: -f1 <<<"$hit")"
}

# -------------------------------------------------------------------- zoxide
_have zoxide && eval "$(zoxide init bash)"
