STEP_NAME="Xcode Command Line Tools"
STEP_DESC="Install the Command Line Tools and accept the Xcode license"

step_run() {
    if xcode-select -p > /dev/null 2>&1; then
        ok "Command Line Tools installed at $(xcode-select -p)"
    else
        info "installing the Command Line Tools — a macOS dialog will open, click Install"
        xcode-select --install > /dev/null 2>&1 || true
        until xcode-select -p > /dev/null 2>&1; do
            sleep 5
        done
        ok "Command Line Tools installed"
    fi

    # With full Xcode present, brew and the compilers refuse to run until the
    # license has been accepted.
    if [[ -d /Applications/Xcode.app ]]; then
        if xcodebuild -license check > /dev/null 2>&1; then
            ok "Xcode license accepted"
        else
            require_sudo "accept the Xcode license"
            run sudo xcodebuild -license accept
        fi
    fi
}
