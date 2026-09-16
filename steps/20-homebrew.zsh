STEP_NAME="Homebrew"
STEP_DESC="Install Homebrew, then install/upgrade everything in apps/homebrew/Brewfile"

step_run() {
    if [[ -x /opt/homebrew/bin/brew ]]; then
        ok "Homebrew installed"
    else
        info "installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ ! -x /opt/homebrew/bin/brew ]]; then
            err "Homebrew install finished but /opt/homebrew/bin/brew is missing"
            return 1
        fi
    fi

    # brew for the rest of this step, and for every future login shell
    eval "$(/opt/homebrew/bin/brew shellenv)"
    dedupe_file "$HOME/.zprofile"
    ensure_line_in_file 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.zprofile"

    # official taps that Homebrew removed; leaving them tapped makes every
    # `brew update` print errors
    local tap out cask
    for tap in homebrew/cask-fonts homebrew/cask-drivers homebrew/bundle; do
        [[ -d $(brew --repository "$tap") ]] || continue
        info "untapping $tap"
        if ! out=$(brew untap "$tap" 2>&1); then
            # casks installed from the old tap pin it; reinstalling them
            # moves them to homebrew/cask
            for cask in ${(f)"$(print -r -- "$out" | sed -n "s#^${tap}/##p" | sort -u)"}; do
                run brew reinstall --cask "$cask"
            done
            run brew untap "$tap"
        fi
    done

    run brew update
    run brew bundle --file="$DOTS_DIR/apps/homebrew/Brewfile"
    run brew upgrade
    run brew cleanup
}
