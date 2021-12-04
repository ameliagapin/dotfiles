#!/bin/sh

pecho() {
    local PRINT_COLOR=6
    if [[ ! -z "$2" ]] ; then
        PRINT_COLOR=$2
    fi

    echo -ne "$(tput setaf "${PRINT_COLOR}")$1$(tput sgr0)"
}

clone() {
    SRC=$1
    LOC=$2

    LOCALREPO_VC_DIR=$LOC/.git

    if [ ! -d $LOCALREPO_VC_DIR ]
    then
        git clone $SRC $LOC > /dev/null || exit 1
    else
        cd $LOC
        git pull $SRC 2>&1 /dev/null || true
    fi

    return 0
}

CUSTOM=$HOME/.oh-my-zsh/custom
OMZ=$HOME/.oh-my-zsh

if [[ ! -d ~/.oh-my-zsh ]]; then
    # Install oh-my-zsh
    pecho "Installing oh-my-zsh...\n"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install spaceship
pecho "Installing spaceship...\n"
clone https://github.com/denysdovhan/spaceship-prompt.git "$CUSTOM/themes/spaceship-prompt"

pecho "Sym linking spaceship...\n"
ln -sf "$CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$CUSTOM/themes/spaceship.zsh-theme" || exit 1

# pecho "Installing spaceship from npm...\n"
# npm install -g spaceship-prompt # || exit 1

pecho "Installing plugins...\n"

pecho "Installing zsh-autosuggetions...\n"
clone https://github.com/zsh-users/zsh-autosuggestions ${OMZ}/plugins/zsh-autosuggestions

pecho "Installing zsh-syntax-highlighting...\n"
clone https://github.com/zsh-users/zsh-syntax-highlighting ${OMZ}/plugins/zsh-syntax-highlighting

pecho "Installing navi...\n"
clone https://github.com/denisidoro/navi ${OMZ}/plugins/navi

# make default
pecho "Setting zsh as default...\n"

# ensure shell is in /etc/shells
sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh) || exit 1

exit 0
