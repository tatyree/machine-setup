#!/usr/bin/env bash
# macOS settings that differ from the defaults on the Mac Studio.
# Safe to re-run. Some changes need a logout to take full effect.
set -euo pipefail

# Appearance
defaults write NSGlobalDomain AppleInterfaceStyle -string Dark
defaults write NSGlobalDomain AppleActionOnDoubleClick -string Minimize

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock tilesize -int 62
defaults write com.apple.dock largesize -int 54
defaults write com.apple.dock mru-spaces -bool false
# Hot corners: 1 = no action
defaults write com.apple.dock wvous-tr-corner -int 1
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-br-corner -int 1

# Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder NewWindowTarget -string PfAF
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

# Menu bar clock
defaults write com.apple.menuextra.clock ShowAMPM -bool true
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true

# Desktop and Stage Manager
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
defaults write com.apple.WindowManager AutoHide -bool true

# Trackpad: tap to click off (built-in and Bluetooth)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false

killall Dock Finder SystemUIServer 2>/dev/null || true
echo "macOS settings applied. Log out and back in for trackpad changes."
