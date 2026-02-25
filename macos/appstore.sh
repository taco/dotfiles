#!/bin/bash
# Interactive Mac App Store installer
# Prompts for each app so you only install what you need.

set -e

echo "==> Mac App Store apps"
echo ""

# Each entry: "id|name|description"
apps=(
  "441258766|Magnet|Window manager — snap windows to edges and corners with keyboard shortcuts"
  "1295203466|Windows App|Remote desktop client for connecting to Windows PCs and Azure Virtual Desktop"
  "1153157709|Speedtest by Ookla|Test your internet download/upload speed and latency"
)

for entry in "${apps[@]}"; do
  IFS='|' read -r id name desc <<< "$entry"
  printf "  %-25s %s\n" "$name" "$desc"
  read -p "  Install? [y/N] " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    mas install "$id"
  fi
  echo ""
done
