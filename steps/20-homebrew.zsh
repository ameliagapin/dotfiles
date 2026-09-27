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
    local tap
    for tap in homebrew/cask-fonts homebrew/cask-drivers homebrew/bundle; do
        [[ -d $(brew --repository "$tap") ]] || continue
        if ! brew untap "$tap" 2> /dev/null; then
            # casks installed from the old tap pin it; --force uninstalls them
            # and brew bundle below reinstalls the ones in the Brewfile
            warn "$tap still has installed casks; untapping with --force (brew bundle reinstalls them)"
            run brew untap --force "$tap"
        fi
    done

    # Homebrew refuses to load anything from a third-party tap until it's
    # trusted; listing a tap in the Brewfile is that decision
    local brewfile=$DOTS_DIR/apps/homebrew/Brewfile trusted
    trusted=$(brew trust --json v1 2> /dev/null || true)
    for tap in ${(f)"$(sed -n 's/^tap "\([^"]*\)".*/\1/p' "$brewfile")"}; do
        if [[ $trusted != *"\"$tap\""* ]]; then
            run brew trust --tap "$tap"
        fi
    done

    run brew update
    run brew bundle --file="$brewfile"
    # upgrades of packages outside the Brewfile can fail for reasons that
    # shouldn't stop the run (dead download URLs, app permissions)
    run brew upgrade || warn "brew upgrade finished with errors, see above"
    run brew cleanup
}
