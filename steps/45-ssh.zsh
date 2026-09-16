STEP_NAME="ssh"
STEP_DESC="Link ~/.ssh/config"

step_run() {
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    link "$DOTS_DIR/apps/ssh/config" "$HOME/.ssh/config"
}
