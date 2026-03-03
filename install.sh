#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

echo "==> Creating symlinks"
ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES/zsh/aliases.zsh" ~/.aliases.zsh
ln -sf "$DOTFILES/zsh/zshrc.darwin.zsh" ~/.zshrc.darwin
ln -sf "$DOTFILES/zsh/zshrc.linux.zsh" ~/.zshrc.linux
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
ln -sf "$DOTFILES/claude/worktree-setup.sh" ~/.claude/worktree-setup.sh
mkdir -p ~/.config/starship
ln -sf "$DOTFILES/starship/starship.toml" ~/.config/starship.toml
mkdir -p ~/.config/gh
ln -sf "$DOTFILES/gh/config.yml" ~/.config/gh/config.yml

if [ "$OS" = "Darwin" ]; then
  ln -sf "$DOTFILES/ssh/.ssh/config.darwin" ~/.ssh/config.local
  mkdir -p ~/Library/Application\ Support/Claude
  ln -sf "$DOTFILES/claude-desktop/claude_desktop_config.json" ~/Library/Application\ Support/Claude/claude_desktop_config.json
  mkdir -p ~/Library/Application\ Support/Cursor/User
  ln -sf "$DOTFILES/cursor/settings.json" ~/Library/Application\ Support/Cursor/User/settings.json
  ln -sf "$DOTFILES/cursor/keybindings.json" ~/Library/Application\ Support/Cursor/User/keybindings.json
  mkdir -p ~/.config/linearmouse
  ln -sf "$DOTFILES/linearmouse/linearmouse.json" ~/.config/linearmouse/linearmouse.json
fi

if [ "$OS" = "Darwin" ]; then
  echo "==> Installing Homebrew packages"
  brew bundle --file="$DOTFILES/Brewfile"
else
  echo "==> Installing Linux packages"
  source "$DOTFILES/linux/packages.sh"
fi

if [ "$OS" = "Darwin" ]; then
  echo "==> Applying macOS defaults"
  source "$DOTFILES/macos/defaults.sh"

  echo "==> Optional apps"
  source "$DOTFILES/macos/appstore.sh"
else
  echo "==> Applying Linux defaults"
  source "$DOTFILES/linux/defaults.sh"
fi

echo "Done!"
