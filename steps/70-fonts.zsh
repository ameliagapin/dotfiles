STEP_NAME="Fonts"
STEP_DESC="Copy apps/fonts into ~/Library/Fonts (existing files are left alone)"

step_run() {
    local before after
    before=$(ls "$HOME/Library/Fonts" | wc -l)
    run rsync -a --ignore-existing "$DOTS_DIR/apps/fonts/." "$HOME/Library/Fonts/"
    after=$(ls "$HOME/Library/Fonts" | wc -l)
    ok "$(( after - before )) new fonts installed"
}
