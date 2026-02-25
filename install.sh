#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing Homebrew packages"
brew bundle --file="$DOTFILES/Brewfile"

echo "==> Creating symlinks"
ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES/git/.gitconfig" ~/.gitconfig
mkdir -p ~/.ssh
ln -sf "$DOTFILES/ssh/.ssh/config" ~/.ssh/config
mkdir -p ~/.claude
ln -sf "$DOTFILES/claude/settings.json" ~/.claude/settings.json
ln -sf "$DOTFILES/claude/statusline.sh" ~/.claude/statusline.sh
mkdir -p ~/Library/Application\ Support/Cursor/User
ln -sf "$DOTFILES/cursor/settings.json" ~/Library/Application\ Support/Cursor/User/settings.json
ln -sf "$DOTFILES/cursor/keybindings.json" ~/Library/Application\ Support/Cursor/User/keybindings.json

echo "==> Applying macOS defaults"
source "$DOTFILES/macos/defaults.sh"

echo "==> Optional apps"
source "$DOTFILES/macos/appstore.sh"

echo "==> Setting up Node via fnm"
fnm install 22

echo "Done!"
