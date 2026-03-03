#!/bin/bash
set -e

echo "==> Setting zsh as default shell"
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

# Optional: keyboard repeat rate (requires gsettings / GNOME)
if command -v gsettings &>/dev/null; then
  gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
  gsettings set org.gnome.desktop.peripherals.keyboard delay 200
fi
