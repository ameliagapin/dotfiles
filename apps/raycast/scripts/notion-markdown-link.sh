#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Notion: Copy Markdown Link
# @raycast.mode silent
# @raycast.packageName Notion
# @raycast.description Copy the current Notion page as a markdown link

if ! pgrep -x "Notion" > /dev/null; then
    echo "Notion is not running"
    exit 1
fi

PAGE_TITLE=$(osascript -e '
tell application "System Events"
    tell process "Notion"
        get name of front window
    end tell
end tell')
PAGE_TITLE="${PAGE_TITLE% - Notion}"

osascript -e '
tell application "System Events"
    tell process "Notion"
        set frontmost to true
        keystroke "l" using {command down}
    end tell
end tell'

sleep 0.3

URL=$(pbpaste)

if [[ "$URL" != *"notion.so"* ]]; then
    echo "Could not get Notion URL — try again"
    exit 1
fi

URL="${URL%%\?*}"

printf '%s' "[${PAGE_TITLE}](${URL})" | pbcopy

echo "Copied: $PAGE_TITLE"
