STEP_NAME="Ghostty"
STEP_DESC="Link ~/.config/ghostty"

step_run() {
    link "$DOTS_DIR/apps/ghostty" "$HOME/.config/ghostty"
}
