#!/bin/bash
# macOS defaults
# Run this script to apply preferred macOS settings.
# Some changes require a logout or restart to take effect.

set -e

echo "==> Applying macOS defaults"

# Close System Preferences/Settings to prevent it from overriding changes
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

###############################################################################
# Keyboard & Input                                                            #
###############################################################################

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Set short delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Remap Caps Lock to Command
# 0x700000039 = Caps Lock, 0x7000000E3 = Left Command
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E3}]}' >/dev/null

# Make the Caps Lock -> Command remap persist across reboots via launch agent
PLIST_PATH="$HOME/Library/LaunchAgents/com.local.KeyRemapping.plist"
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$PLIST_PATH" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.local.KeyRemapping</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/hidutil</string>
    <string>property</string>
    <string>--set</string>
    <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E3}]}</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
PLIST

###############################################################################
# Appearance                                                                  #
###############################################################################

# Auto-switch between light and dark mode
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

###############################################################################
# Dock                                                                        #
###############################################################################

# Position Dock on the left
defaults write com.apple.dock orientation -string "left"

# Enable magnification
defaults write com.apple.dock magnification -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Hot Corners                                                                 #
# Values: 0=none, 2=Mission Control, 3=App Windows, 4=Desktop, 5=Screensaver #
#         6=Disable Screensaver, 10=Put Display to Sleep, 13=Lock Screen      #
###############################################################################

# Bottom-left corner: Lock Screen
defaults write com.apple.dock wvous-bl-corner -int 13
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Kill affected apps                                                          #
###############################################################################

for app in "Dock" "Finder" "SystemUIServer"; do
  killall "$app" &>/dev/null || true
done

echo "Done! Some changes require a logout/restart to take effect."
