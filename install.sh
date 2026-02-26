#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing Homebrew packages"
brew bundle --file="$DOTFILES/Brewfile"

echo "==> Creating symlinks"
ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES/zsh/aliases.zsh" ~/.aliases.zsh
ln -sf "$DOTFILES/git/.gitconfig" ~/.gitconfig
ln -sf "$DOTFILES/git/.gitignore_global" ~/.gitignore_global
ln -sf "$DOTFILES/git/.gitmessage" ~/.gitmessage
ln -sf "$DOTFILES/npm/.npmrc" ~/.npmrc
mkdir -p ~/.ssh
ln -sf "$DOTFILES/ssh/.ssh/config" ~/.ssh/config
mkdir -p ~/.claude
ln -sf "$DOTFILES/claude/settings.json" ~/.claude/settings.json
ln -sf "$DOTFILES/claude/statusline.sh" ~/.claude/statusline.sh
ln -sfn "$DOTFILES/claude/skills" ~/.claude/skills
mkdir -p ~/.config/starship
ln -sf "$DOTFILES/starship/starship.toml" ~/.config/starship.toml
mkdir -p ~/.config/gh
ln -sf "$DOTFILES/gh/config.yml" ~/.config/gh/config.yml
mkdir -p ~/Library/Application\ Support/Claude
ln -sf "$DOTFILES/claude-desktop/claude_desktop_config.json" ~/Library/Application\ Support/Claude/claude_desktop_config.json
mkdir -p ~/Library/Application\ Support/Cursor/User
ln -sf "$DOTFILES/cursor/settings.json" ~/Library/Application\ Support/Cursor/User/settings.json
ln -sf "$DOTFILES/cursor/keybindings.json" ~/Library/Application\ Support/Cursor/User/keybindings.json
mkdir -p ~/.config/linearmouse
ln -sf "$DOTFILES/linearmouse/linearmouse.json" ~/.config/linearmouse/linearmouse.json

echo "==> Applying macOS defaults"
source "$DOTFILES/macos/defaults.sh"

echo "==> Optional apps"
source "$DOTFILES/macos/appstore.sh"

echo "==> Setting up Node via fnm"
fnm install 24

echo "Done!"
