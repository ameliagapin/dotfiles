STEP_NAME="macOS defaults"
STEP_DESC="Set Finder, Dock, sound, keyboard, trackpad and default-app preferences"

# The built-in trackpad and a Magic Trackpad keep separate preferences, so
# every gesture is written to both domains.
MACOS_TRACKPAD_DOMAINS=(
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
)

# HID usage codes: 0x700000039 is caps lock, 0x700000029 is escape.
MACOS_CAPS_LOCK=30064771129
MACOS_ESCAPE=30064771113

# How many writes actually changed something, so a re-run stays quiet and only
# restarts Finder and the Dock when there's a reason to.
typeset -gi MACOS_CHANGED=0

# macos_set [-currentHost] <domain> <key> <type> <value> — write a default only
# when it differs from what's already there. Plain `if`, never `[[ … ]] && …`:
# a bare test that fails is enough to end the function under errexit.
macos_set() {
    local host=()
    if [[ $1 == -currentHost ]]; then
        host=(-currentHost)
        shift
    fi
    local domain=$1 key=$2 type=$3 value=$4 want=$4 current
    # `defaults read` prints booleans as 1/0, so compare against that
    if [[ $type == -bool ]]; then
        if [[ $value == true ]]; then want=1; else want=0; fi
    fi
    current=$(defaults $host read "$domain" "$key" 2> /dev/null || true)
    if [[ $current == $want ]]; then
        return 0
    fi
    defaults $host write "$domain" "$key" "$type" "$value"
    info "$key = $value${current:+ (was $current)}"
    MACOS_CHANGED=$(( MACOS_CHANGED + 1 ))
}

# Nlsv is list view; the others are icnv, clmv and glyv.
# The toolbar is deliberately missing: unlike the status and path bars it has no
# top-level key, only a ShowToolbar inside each saved window state, which Finder
# rewrites itself. It's on by default anyway.
macos_finder() {
    macos_set com.apple.finder FXPreferredViewStyle -string Nlsv
    macos_set com.apple.finder ShowStatusBar -bool true
    macos_set com.apple.finder ShowPathbar -bool true
    macos_set com.apple.finder ShowHardDrivesOnDesktop -bool false
    macos_set com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
    macos_set com.apple.finder ShowMountedServersOnDesktop -bool false
    macos_set com.apple.finder FinderSpawnTab -bool true
    macos_set com.apple.finder ShowRecentTags -bool false
    macos_set NSGlobalDomain AppleShowAllExtensions -bool true
}

macos_dock() {
    macos_set com.apple.dock magnification -bool false
    macos_set com.apple.dock autohide -bool true
    macos_set com.apple.dock show-recents -bool false
}

macos_sound() {
    # alert volume, 0.0 to 1.0
    macos_set NSGlobalDomain com.apple.sound.beep.volume -float 0
    macos_set NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0
    # "play feedback when volume is changed": this is the long-standing key but
    # it's absent from a stock macOS 26/27, so treat it as best-effort and check
    # System Settings → Sound once
    macos_set NSGlobalDomain com.apple.sound.beep.feedback -int 0
}

# Each keyboard carries its own remap, keyed by vendor and product id in
# decimal, so map whatever is attached right now.
macos_keyboard() {
    local -a boards
    local board vendor product key current
    # hidutil lists every device twice (services and devices), hence sort -u
    boards=( ${(f)"$(
        hidutil list --matching '{"PrimaryUsagePage":1,"PrimaryUsage":6}' 2> /dev/null \
            | awk '/^0x/ { print $1 "-" $2 }' | sort -u
    )"} )
    if (( ${#boards} == 0 )); then
        warn "no keyboards found — skipping the caps lock remap"
        return 0
    fi
    for board in $boards; do
        vendor=$(( ${board%-*} ))
        product=$(( ${board#*-} ))
        key=com.apple.keyboard.modifiermapping.${vendor}-${product}-0
        current=$(defaults -currentHost read NSGlobalDomain "$key" 2> /dev/null || true)
        if [[ $current == *$MACOS_CAPS_LOCK* ]]; then
            if [[ $current != *$MACOS_ESCAPE* ]]; then
                warn "keyboard $vendor-$product: caps lock is already remapped elsewhere — leaving it"
            fi
            continue
        fi
        # -array-add rather than -array: keep any other modifier remaps this
        # keyboard already has
        defaults -currentHost write NSGlobalDomain "$key" -array-add \
            "{HIDKeyboardModifierMappingSrc = $MACOS_CAPS_LOCK; HIDKeyboardModifierMappingDst = $MACOS_ESCAPE;}"
        info "caps lock → escape on keyboard $vendor-$product"
        MACOS_CHANGED=$(( MACOS_CHANGED + 1 ))
    done
}

# Gesture keys take 2 to enable at that finger count and 0 to disable, so
# choosing a finger count means setting one key and clearing its sibling.
macos_trackpad() {
    local domain
    for domain in $MACOS_TRACKPAD_DOMAINS; do
        macos_set "$domain" Clicking -bool true
        # look up & data detectors: tap with three fingers
        macos_set "$domain" TrackpadThreeFingerTapGesture -int 2
        # swipe between full-screen apps: four fingers, not three
        macos_set "$domain" TrackpadThreeFingerHorizSwipeGesture -int 0
        macos_set "$domain" TrackpadFourFingerHorizSwipeGesture -int 2
        # mission control (up) and app exposé (down): four fingers
        macos_set "$domain" TrackpadThreeFingerVertSwipeGesture -int 0
        macos_set "$domain" TrackpadFourFingerVertSwipeGesture -int 2
    done

    # force click and haptic feedback. Built-in trackpad only — the Bluetooth
    # domain has no such keys — and the name is inverted: suppressed 0 means on.
    macos_set com.apple.AppleMultitouchTrackpad ForceSuppressed -bool false
    macos_set com.apple.AppleMultitouchTrackpad ActuateDetents -int 1

    # which look-up gesture is selected: 0 is the three-finger tap above, 1
    # would be force click with one finger
    macos_set NSGlobalDomain com.apple.trackpad.forceClick -int 0
    # tap to click, for the login window and for apps that read the global domain
    macos_set NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    macos_set -currentHost NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    # swipe between pages: scroll left or right with two fingers
    macos_set NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
    # one finger count covers both vertical swipes, so mission control and app
    # exposé are turned on individually here
    macos_set com.apple.dock showMissionControlGestureEnabled -bool true
    macos_set com.apple.dock showAppExposeGestureEnabled -bool true
}

# duti goes through the LaunchServices API. Editing
# com.apple.launchservices.secure.plist by hand needs an lsregister rebuild and
# tends to take unrelated associations with it.
macos_default_apps() {
    if ! has duti; then
        warn "duti is not installed — skipping file associations (run the homebrew step)"
        return 0
    fi
    # one UTI covers both .md and .markdown
    macos_assoc abnerworks.Typora net.daringfireball.markdown
    macos_assoc com.apple.TextEdit public.json
}

# macos_assoc <bundle id> <uti> — hand every role for <uti> to <bundle id>.
macos_assoc() {
    local bundle=$1 uti=$2
    if ! duti -s "$bundle" "$uti" all 2> /dev/null; then
        warn "could not set $uti → $bundle (is the app installed?)"
        return 0
    fi
    ok "$uti → $bundle"
}

macos_apply() {
    local activate=/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings

    if (( MACOS_CHANGED == 0 )); then
        ok "macOS defaults already set"
        return 0
    fi

    # Finder and the Dock only read these at launch; both come straight back
    killall Finder 2> /dev/null || true
    killall Dock 2> /dev/null || true
    if [[ -x $activate ]]; then
        "$activate" -u > /dev/null 2>&1 || true
    fi

    ok "$MACOS_CHANGED setting(s) changed"
    info "log out and back in for the caps lock remap and the trackpad gestures"
}

step_run() {
    macos_finder
    macos_dock
    macos_sound
    macos_keyboard
    macos_trackpad
    macos_default_apps
    macos_apply
}
