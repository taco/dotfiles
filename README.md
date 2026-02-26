# dotfiles

Personal macOS dotfiles managed with symlinks.

## What's included

**Shell** — Zsh with oh-my-zsh, starship prompt, zoxide, fish-like autosuggestions and syntax highlighting

**Git** — Config with 40+ aliases, global gitignore, commit message template

**Editors** — Claude Code (settings, plugins, statusline, global skills), Cursor (Gruvbox theme, keybindings)

**Terminal** — iTerm2 with Gruvbox color scheme, Nerd Fonts (Fira Code, Hack, JetBrains Mono, Meslo LG)

**macOS** — Caps Lock remapped to Command, fast key repeat, Dock on left, Finder tweaks, auto light/dark mode, hot corners

**CLI tools** — gh, bat, fnm, mkcert, mtr, neonctl, railway, wakeonlan

**Apps** — Optional interactive installer for 1Password, Claude, Cursor, Docker, Discord, Signal, Magnet, Xcode, and more

## Tracked files

| Directory | Contents |
|---|---|
| `zsh/` | `.zshrc`, `aliases.zsh` |
| `git/` | `.gitconfig`, `.gitignore_global`, `.gitmessage` |
| `ssh/` | SSH host config (win, wsl, github) |
| `claude/` | Claude Code settings, statusline script, and global skills |
| `claude-desktop/` | Claude Desktop config |
| `cursor/` | Cursor editor settings and keybindings |
| `starship/` | Starship prompt config |
| `gh/` | GitHub CLI config |
| `npm/` | `.npmrc` (save-exact, engine-strict) |
| `iterm2/` | iTerm2 preferences plist |
| `linearmouse/` | LinearMouse settings |
| `macos/` | `defaults.sh` (system prefs), `appstore.sh` (optional apps) |
| `Brewfile` | Homebrew packages, casks, and VS Code extensions |

## Bootstrap a new machine

```bash
git clone git@github.com:travisj/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
./install.sh
```

The install script will:

1. Install Homebrew packages from `Brewfile`
2. Symlink all config files to their expected locations
3. Apply macOS system defaults
4. Prompt for optional app installs
5. Install Node v24 via fnm
