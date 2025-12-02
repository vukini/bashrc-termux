# bashrc-termux

A simple bashrc setup for Termux on Android that provides useful aliases, functions, and customizations for a better terminal experience.

## Features

- **Custom prompt** - Clean and colorful prompt showing user@termux:directory
- **Useful aliases** - Shortcuts for common commands like navigation, file listing, and git
- **Termux shortcuts** - Quick commands for package management (`update`, `install`, `search`)
- **Helper functions** - `mkcd`, `extract`, `backup`, and more
- **History improvements** - Better history settings with deduplication
- **Shell enhancements** - Autocorrect, extended globbing, and case-insensitive matching

## Installation

### Quick Install

```bash
curl -o ~/.bashrc https://raw.githubusercontent.com/vukini/bashrc-termux/main/.bashrc && source ~/.bashrc
```

### Manual Install

1. Clone the repository:
   ```bash
   git clone https://github.com/vukini/bashrc-termux.git
   ```

2. Copy the `.bashrc` file to your home directory:
   ```bash
   cp bashrc-termux/.bashrc ~/.bashrc
   ```

3. Reload your shell:
   ```bash
   source ~/.bashrc
   ```

## Aliases Reference

### Navigation
| Alias | Command |
|-------|---------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |

### File Operations
| Alias | Command |
|-------|---------|
| `ll` | `ls -alF` |
| `la` | `ls -A` |
| `l` | `ls -CF` |

### Termux Package Management
| Alias | Command |
|-------|---------|
| `update` | `pkg update && pkg upgrade` |
| `install` | `pkg install` |
| `search` | `pkg search` |
| `uninstall` | `pkg uninstall` |
| `pkgs` | `pkg list-installed` |

### Storage Shortcuts
| Alias | Command |
|-------|---------|
| `storage` | `termux-setup-storage` |
| `sdcard` | `cd /sdcard` |
| `downloads` | `cd /sdcard/Download` |

### Git
| Alias | Command |
|-------|---------|
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gl` | `git log --oneline -10` |
| `gd` | `git diff` |

## Functions

### `mkcd <directory>`
Create a directory and change into it immediately.

```bash
mkcd my-new-project
```

### `extract <file>`
Extract various archive formats automatically.

```bash
extract file.tar.gz
extract archive.zip
```

### `backup <file>`
Create a timestamped backup of a file.

```bash
backup important-file.txt
# Creates: important-file.txt.bak.20231215_143022
```

### `path`
Display PATH variable in a readable format (one entry per line).

```bash
path
```

## Customization

Feel free to modify the `.bashrc` file to suit your needs. Common customizations include:

- Change the default editor (`EDITOR` variable)
- Modify the prompt (`PS1` variable)
- Add your own aliases and functions

## Requirements

- [Termux](https://termux.dev/) installed on Android
- Bash shell (default in Termux)

## License

MIT License - Feel free to use and modify as needed.