# dotfiles

Personal dotfiles managed with symlinks.

## What's tracked

- `zsh/.zshrc` — Zsh config (oh-my-zsh, starship, fnm, aliases)
- `git/.gitconfig` — Git config and aliases
- `ssh/.ssh/config` — SSH host aliases (no keys)
- `claude/settings.json` — Claude Code settings
- `claude/statusline.sh` — Claude Code statusline script
- `Brewfile` — Homebrew packages and casks

## Bootstrap a new machine

```bash
git clone git@github.com:travisj/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
./install.sh
```

This will install Homebrew packages, create symlinks, and set up Node via fnm.
