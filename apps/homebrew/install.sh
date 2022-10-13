#!/bin/sh
set -e

which -s brew
if [[ $? != 0 ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"

	echo "Please restart your terminal and continue with the install script"
else
	echo "Homebrew already installed, skipping"
fi

exit 0
