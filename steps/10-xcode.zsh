STEP_NAME="Xcode Command Line Tools"
STEP_DESC="Install the Command Line Tools and accept the Xcode license"
STEP_REQUIRED=1  # nothing else can build without a working compiler

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

    # A Mac can end up with Command Line Tools older than its macOS SDK, and
    # then every C link fails ("tapi error: malformed file ... unknown
    # architecture"). Homebrew builds and treesitter parsers would be the
    # first casualties, several steps from here, so check it now.
    local tmp
    tmp=$(mktemp -d)
    print -r -- 'int main(void) { return 0; }' > "$tmp/probe.c"
    if cc -o "$tmp/probe" "$tmp/probe.c" > "$tmp/log" 2>&1; then
        ok "C toolchain compiles and links"
        rm -rf "$tmp"
    else
        err "the C toolchain cannot link a trivial program"
        cat "$tmp/log" >&2
        if grep -qE 'tapi error|unknown architecture' "$tmp/log"; then
            warn "the Command Line Tools look older than the macOS SDK:"
            warn "  ld:  $(ld -v 2>&1 | head -1)"
            warn "  SDK: $(xcrun --show-sdk-version 2>&1) at $(xcrun --show-sdk-path 2>&1)"
            warn "reinstall them, then run this step again:"
            warn "  sudo rm -rf /Library/Developer/CommandLineTools && xcode-select --install"
        fi
        rm -rf "$tmp"
        return 1
    fi
}
