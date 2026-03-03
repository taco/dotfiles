# dotfiles

Personal dotfiles for macOS and Ubuntu/WSL2, managed with symlinks.

## What's included

**Shell** — Zsh with oh-my-zsh, starship prompt, zoxide, fish-like autosuggestions and syntax highlighting

**Git** — Config with 40+ aliases, global gitignore, commit message template

**Editors** — Claude Code (settings, plugins, statusline, global skills), Cursor (Gruvbox theme, keybindings)

**Terminal** — iTerm2 with Gruvbox color scheme, Nerd Fonts (Fira Code, Hack, JetBrains Mono, Meslo LG)

**macOS** — Caps Lock remapped to Command, fast key repeat, Dock on left, Finder tweaks, auto light/dark mode, hot corners

**CLI tools** — gh, bat, fnm, mkcert, mtr, neonctl, railway, wakeonlan

**Apps** — Optional interactive installer for 1Password, Claude, Cursor, Docker, Discord, Signal, Magnet, Xcode, and more

## OS support

One repo, one branch. All terminal/CLI configs (zsh, git, aliases, claude, starship, npm, gh) are shared across macOS and Linux. Only package installation, a few zsh lines, and SSH keychain differ. GUI app configs (Cursor, Claude Desktop, iTerm2, linearmouse) are macOS-only.

`install.sh` detects the OS via `uname -s` and applies the appropriate packages and defaults. `.zshrc` sources `~/.zshrc.darwin` or `~/.zshrc.linux` for OS-specific plugins, shell env, and editor settings.

## Tracked files

| Directory | Contents |
|---|---|
| `zsh/` | `.zshrc`, `aliases.zsh`, `zshrc.darwin.zsh`, `zshrc.linux.zsh` |
| `git/` | `.gitconfig`, `.gitignore_global`, `.gitmessage` |
| `ssh/` | SSH host config (win, wsl, github), `config.darwin` (UseKeychain) |
| `claude/` | Claude Code settings, statusline script, and global skills |
| `claude-desktop/` | Claude Desktop config (macOS only) |
| `cursor/` | Cursor editor settings and keybindings (macOS only) |
| `starship/` | Starship prompt config |
| `gh/` | GitHub CLI config |
| `npm/` | `.npmrc` (save-exact, engine-strict) |
| `iterm2/` | iTerm2 preferences plist (macOS only) |
| `linearmouse/` | LinearMouse settings (macOS only) |
| `macos/` | `defaults.sh` (system prefs), `appstore.sh` (optional apps) |
| `linux/` | `packages.sh` (apt + fnm + starship), `defaults.sh` (chsh, gsettings) |
| `Brewfile` | Homebrew packages, casks, and VS Code extensions |

## Bootstrap a new machine

```bash
git clone git@github.com:travisj/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
./install.sh
```

The install script will:

1. Install packages (Homebrew on macOS, apt + curl installers on Linux)
2. Symlink all config files to their expected locations
3. Apply system defaults (macOS prefs or Linux chsh/gsettings)
4. Prompt for optional app installs (macOS only)
5. Install Node v24 via fnm
