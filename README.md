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

## Neovim

The config is its own repo, [nvim-android](https://github.com/vukini/nvim-android).

```sh
pkg install luarocks clang nodejs-lts unzip
git clone https://github.com/vukini/nvim-android ~/.config/nvim
nvim   # first start installs the plugins and builds the parsers; give it a few minutes
```

- `luarocks` and `clang` build Neorg's two tree-sitter parsers. Without
  `luarocks`, lazy.nvim tries to download its own Lua, which fails on Termux.
- `clang` also builds the parsers nvim-treesitter installs.
- `nodejs-lts` is for pyright, which mason installs with npm.

## Emacs

The config is its own repo, [emacs-android](https://github.com/vukini/emacs-android):
the laptop's [emacs-void](https://github.com/vukini/emacs-void), adapted for a
terminal-only Emacs on a phone.

```sh
pkg install emacs sbcl clang nodejs-lts
npm install -g pyright
git clone https://github.com/vukini/emacs-android ~/.emacs.d
emacs   # first start downloads and compiles about forty packages; let it finish
```

- `sbcl` is for SLIME, `clang` brings `clangd` for C and C++, and `pyright`
  is the Python server. Emacs starts without them; that language just has no
  server until its program is installed.
- Keys a terminal can't send have a second key there: `M-o` for Embark,
  `M-g c` for avy. The repo's README has the list.
- The aliases `ee` and `eb` in `.bash_aliases` turn on once `emacs` is installed.

Private aliases (servers, hosts) go in `~/.bashrc.local`, which is not in this repo.
