#!/bin/sh
set -e

xcode-select -p 1>/dev/null
if [ $? != 0 ]; then
    xcode-select --install
fi

sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept
