#!/bin/bash
set -e

echo "==> Updating apt"
sudo apt-get update -qq

echo "==> Installing apt packages"
sudo apt-get install -y \
  bat \
  curl \
  gh \
  jq \
  mtr \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zoxide

echo "==> Installing fnm (Node version manager)"
if ! command -v fnm &>/dev/null; then
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir ~/.local/bin --skip-shell
fi

echo "==> Installing starship prompt"
if ! command -v starship &>/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir ~/.local/bin --yes
fi

echo "==> Setting up Node via fnm"
export PATH="$HOME/.local/bin:$PATH"
eval "$(fnm env)"
fnm install 24
