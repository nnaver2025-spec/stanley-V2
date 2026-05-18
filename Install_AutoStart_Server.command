#!/bin/bash
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PLIST="$HOME/Library/LaunchAgents/com.local.druckenmiller-dashboard.plist"
STATUS_URL="http://127.0.0.1:8080/api/status"

mkdir -p "$HOME/Library/LaunchAgents"

cat > "$PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.druckenmiller-dashboard</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/zsh</string>
        <string>-lc</string>
        <string>curl -fsS --max-time 2 "$STATUS_URL" >/dev/null 2>&amp;1 &amp;&amp; exit 0; cd "$DIR" &amp;&amp; STANLEY_NO_BROWSER=1 exec python3 server.py</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <dict>
        <key>SuccessfulExit</key>
        <false/>
    </dict>
    <key>WorkingDirectory</key>
    <string>$DIR</string>
    <key>StandardOutPath</key>
    <string>$DIR/launchd-server.out.log</string>
    <key>StandardErrorPath</key>
    <string>$DIR/launchd-server.err.log</string>
</dict>
</plist>
PLIST

launchctl bootout "gui/$(id -u)" "$PLIST" >/dev/null 2>&1 || true
launchctl bootstrap "gui/$(id -u)" "$PLIST"
launchctl kickstart -k "gui/$(id -u)/com.local.druckenmiller-dashboard"

echo "Installed. After macOS login, the dashboard server will start automatically."
echo "Open: http://127.0.0.1:8080"
