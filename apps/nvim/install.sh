#!/bin/sh
set -e

pecho() {
    local PRINT_COLOR=6
    if [[ ! -z "$2" ]] ; then
        PRINT_COLOR=$2
    fi

    echo "$(tput setaf "${PRINT_COLOR}")$1$(tput sgr0)"
}

pecho "Creating vim undo directory...\n"
mkdir -p ~/.vim/undo

exit 0
