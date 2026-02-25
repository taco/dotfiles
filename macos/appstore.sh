#!/bin/bash
# Interactive app installer
# Prompts for each app so you only install what you need.

set -e

###############################################################################
# Homebrew Casks                                                              #
###############################################################################

echo ""
echo "==> Optional apps (Homebrew casks)"
echo ""

# Each entry: "cask-name|Display Name|description"
casks=(
  "1password|1Password|Password manager and secure vault"
  "aldente|AlDente|Battery charge limiter to extend MacBook battery lifespan"
  "caffeine|Caffeine|Prevent your Mac from going to sleep"
  "claude|Claude|Anthropic's AI assistant desktop app"
  "cursor|Cursor|AI-powered code editor"
  "discord|Discord|Voice, video, and text chat"
  "docker|Docker Desktop|Container platform for building and running apps"
  "multiviewer|MultiViewer|Watch multiple F1 streams simultaneously"
  "signal|Signal|End-to-end encrypted messaging"
  "wootility|Wootility|Configuration tool for Wooting keyboards"
)

for entry in "${casks[@]}"; do
  IFS='|' read -r cask name desc <<< "$entry"
  printf "  %-25s %s\n" "$name" "$desc"
  read -p "  Install? [y/N] " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    brew install --cask "$cask"
  fi
  echo ""
done

###############################################################################
# Mac App Store                                                               #
###############################################################################

echo "==> Optional apps (Mac App Store)"
echo ""

# Each entry: "id|name|description"
mas_apps=(
  "441258766|Magnet|Window manager — snap windows to edges and corners with keyboard shortcuts"
  "497799835|Xcode|Apple's IDE for macOS, iOS, watchOS, and tvOS development"
  "1295203466|Windows App|Remote desktop client for connecting to Windows PCs and Azure Virtual Desktop"
  "1153157709|Speedtest by Ookla|Test your internet download/upload speed and latency"
)

for entry in "${mas_apps[@]}"; do
  IFS='|' read -r id name desc <<< "$entry"
  printf "  %-25s %s\n" "$name" "$desc"
  read -p "  Install? [y/N] " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    mas install "$id"
  fi
  echo ""
done
