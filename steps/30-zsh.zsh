STEP_NAME="zsh"
STEP_DESC="Oh My Zsh, spaceship prompt and plugins; link zsh dotfiles; zsh as login shell"

step_run() {
    local omz=$HOME/.oh-my-zsh
    local custom=$omz/custom

    if [[ -d $omz ]]; then
        ok "Oh My Zsh installed"
        # an old version of this repo installed it as root
        if [[ ! -O $omz ]]; then
            require_sudo "fix ownership of $omz (it was installed as root)"
            run sudo chown -R "${USER}:staff" "$omz"
        fi
        if git -C "$omz" pull --ff-only --quiet; then
            ok "Oh My Zsh up to date"
        else
            warn "could not update Oh My Zsh (offline or diverged) — leaving as is"
        fi
    else
        info "installing Oh My Zsh"
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    clone_or_pull https://github.com/spaceship-prompt/spaceship-prompt.git "$custom/themes/spaceship-prompt"
    link "$custom/themes/spaceship-prompt/spaceship.zsh-theme" "$custom/themes/spaceship.zsh-theme"
    clone_or_pull https://github.com/zsh-users/zsh-autosuggestions.git "$custom/plugins/zsh-autosuggestions"
    clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom/plugins/zsh-syntax-highlighting"

    link "$DOTS_DIR/apps/zsh/zshrc"       "$HOME/.zshrc"
    link "$DOTS_DIR/apps/zsh/exports"     "$HOME/.exports"
    link "$DOTS_DIR/apps/zsh/aliases"     "$HOME/.aliases"
    link "$DOTS_DIR/apps/zsh/functions"   "$HOME/.functions"
    link "$DOTS_DIR/apps/navi/cheatsheets" "$HOME/.cheatsheets"
    # work-machine-only file, not in the repo
    if [[ -e $DOTS_DIR/apps/zsh/sublime ]]; then
        link "$DOTS_DIR/apps/zsh/sublime" "$HOME/.sublime"
    else
        info "no apps/zsh/sublime on this machine — skipping ~/.sublime"
    fi

    # login shell
    local zsh_bin=/opt/homebrew/bin/zsh current
    [[ -x $zsh_bin ]] || zsh_bin=/bin/zsh
    ensure_line_in_file "$zsh_bin" /etc/shells
    current=$(dscl . -read "$HOME" UserShell 2> /dev/null)
    current=${current#UserShell: }
    if [[ $current == $zsh_bin ]]; then
        ok "login shell is $zsh_bin"
    elif confirm "change login shell from ${current:-unknown} to $zsh_bin?"; then
        run chsh -s "$zsh_bin"
    else
        warn "login shell left as ${current:-unknown}"
    fi
}
