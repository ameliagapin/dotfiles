STEP_NAME="iTerm2"
STEP_DESC="Link ~/.iterm and point iTerm2's preferences at it"

step_run() {
    link "$DOTS_DIR/apps/iterm" "$HOME/.iterm"

    local current
    current=$(defaults read com.googlecode.iterm2 PrefsCustomFolder 2> /dev/null || true)
    if [[ -n $current && ${current:A} == ${DOTS_DIR}/apps/iterm ]]; then
        ok "iTerm2 already loads its preferences from $current"
    else
        # iTerm2 rewrites its defaults on quit, so only touch them when needed
        run defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.iterm"
        run defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
        info "restart iTerm2 to pick up the preferences folder"
    fi
}
