#!/bin/sh
set -e

xcode-select --install

sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept
