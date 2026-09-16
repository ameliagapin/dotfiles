STEP_NAME="git"
STEP_DESC="Link ~/.gitconfig"

step_run() {
    link "$DOTS_DIR/apps/git/gitconfig" "$HOME/.gitconfig"
}
