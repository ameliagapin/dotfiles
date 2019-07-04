#!/usr/bin/env bash

# Automated installer for ameliagapin/dotfiles using dotbot (anishathalye/dotbot)

function pecho() {
    local PRINT_COLOR=6
    if [[ ! -z "$2" ]] ; then
        PRINT_COLOR=$2
    fi

    echo -ne "$(tput setaf "${PRINT_COLOR}")$1$(tput sgr0)"
}

###############################################################################
# dotbot install
###############################################################################

pecho "Installing submodules:\n"

git submodule add -f https://github.com/anishathalye/dotbot.git
git submodule add -f https://github.com/sobolevn/dotbot-brewfile.git
git submodule add -f https://github.com/sobolevn/dotbot-pip.git
git submodule add -f https://gitlab.com/flyingchipmunk/dotbot-yum.git
git submodule add -f https://github.com/ameliagapin/dotbot-npm.git
git submodule add -f https://github.com/rubenvereecken/dotbot-apt-get.git

# pecho "Updating submodules:\n"

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

cd "${BASEDIR}"
# 
# git submodule update --init --recursive "${DOTBOT_DIR}"
# git submodule update --init --recursive "dotbot-brewfile"
# git submodule update --init --recursive "dotbot-pip"
# git submodule update --init --recursive "dotbot-yum"
# git submodule update --init --recursive "dotbot-npm"
# git submodule update --init --recursive "dotbot-apt-get"

###############################################################################
# Link dotfiles
###############################################################################

CONFIG="install.conf.yaml"

pecho "Would you like to link dotfiles [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Linking dotfiles:"

    "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
fi

###############################################################################
# Install apt-get packages
###############################################################################

APT_GET_CMD=$(which apt-get)

if [[ ! -z $APT_GET_CMD ]] ; then
    CONFIG="aptget.conf.yaml"

    pecho "Would you like to install apt-get packages [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
        echo "Installing apt-get packages:"

        "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -p dotbot-apt-get/aptget.py -c "${CONFIG}" "${@}"
    fi
fi


