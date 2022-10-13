#!/bin/sh
set -e

xcode-select -p 1>/dev/null
if [ $? != 0 ]; then
    xcode-select --install
fi

sudo xcodebuild -license accept
