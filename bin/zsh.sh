#!/usr/bin/env bash

# zsh should already be installed
source bin/utils.sh || exit 1

pecho "Installing spaceship-prompt npm package...\n"
sudo npm install -g spaceship-prompt # || exit 1

pecho "Cloning spaceship-prompt-theme...\n"
clone https://github.com/denysdovhan/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt" || exit 1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$HOME/.oh-my-zsh/themes/spaceship.zsh-theme" || exit 1

# install plugins

pecho "Installing plugins...\n"
clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions || exit 1
clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting || exit 1

exit 0
