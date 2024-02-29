#!/bin/sh
set -e

# Make TextEdit open to an empty document instead of showing the open panel
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false
