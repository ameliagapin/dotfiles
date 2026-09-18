STEP_NAME="SSH key"
STEP_DESC="Generate an ed25519 SSH key for this Mac (keychain-backed) and offer to add it to GitHub"

step_run() {
    local key=$HOME/.ssh/id_ed25519 pub=$HOME/.ssh/id_ed25519.pub generated=0
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    if [[ -f $key && -f $pub ]]; then
        ok "SSH key exists: $key"
    else
        # the comment becomes the key's default title on GitHub
        local machine
        machine=$(scutil --get ComputerName 2> /dev/null || hostname -s)
        info "generating a new ed25519 key — choose a passphrase when asked; it's stored in your keychain"
        run ssh-keygen -t ed25519 -C "${USER}@${machine}" -f "$key"
        generated=1
    fi

    # load it into ssh-agent, with the passphrase remembered in the keychain
    local fingerprint loaded
    fingerprint=$(ssh-keygen -lf "$pub" | awk '{print $2}')
    loaded=$(ssh-add -l 2> /dev/null || true)
    if [[ $loaded == *"$fingerprint"* ]]; then
        ok "key is loaded in ssh-agent"
    else
        run ssh-add --apple-use-keychain "$key"
    fi

    print
    print -r -- "$(<"$pub")"
    print
    if has pbcopy; then
        pbcopy < "$pub"
        ok "public key copied to the clipboard"
    fi

    (( generated )) || return 0

    if confirm "add it to your GitHub account now?"; then
        run open "https://github.com/settings/ssh/new"
        info "paste the key from your clipboard and save it"
        if confirm "test the connection to GitHub once it's added?"; then
            local reply
            # GitHub answers on a non-zero exit (no shell access), so read the message
            reply=$(ssh -T -o StrictHostKeyChecking=accept-new git@github.com 2>&1 || true)
            if [[ $reply == *"successfully authenticated"* ]]; then
                ok "GitHub: $reply"
            else
                warn "GitHub did not accept the key yet: $reply"
            fi
        fi
    fi
}
