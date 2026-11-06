# bashrc-termux

My Termux shell setup, so a phone can be rebuilt from scratch.

| File | Goes to | What it is |
| --- | --- | --- |
| `.bashrc` | `~/.bashrc` | PATH, editor, prompt, history, fzf keys; sources the two files below |
| `.bash_aliases` | `~/.bash_aliases` | Aliases and functions, adapted from [dotfiles](https://github.com/vukini/dotfiles) for Termux |
| `.tmux.conf` | `~/.tmux.conf` | Touch scrolling, long scrollback, fast Esc |
| `.termux/termux.properties` | `~/.termux/termux.properties` | Two-row extra keys (Esc, Tab, Ctrl, Alt, arrows, drawer) |

`.2025-12-02.bashrc` is the bashrc from the previous phone, kept for reference.

## Restore

```sh
pkg install git gh ripgrep fd fzf jq tmux neovim termux-api
pkg install eza bat zoxide   # optional: turns on the eza aliases, previews and `z`

git clone https://github.com/vukini/bashrc-termux ~/src/bashrc-termux
cd ~/src/bashrc-termux
cp .bashrc .bash_aliases .tmux.conf ~/
mkdir -p ~/.termux && cp .termux/termux.properties ~/.termux/
termux-reload-settings
source ~/.bashrc
```

`termux-api` needs the Termux:API app as well, installed from the same source
as Termux. Without the app its commands hang.

Private aliases (servers, hosts) go in `~/.bashrc.local`, which is not in this repo.
