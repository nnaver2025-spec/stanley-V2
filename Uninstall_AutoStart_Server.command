#!/bin/bash
set -euo pipefail

PLIST="$HOME/Library/LaunchAgents/com.local.druckenmiller-dashboard.plist"

launchctl bootout "gui/$(id -u)" "$PLIST" >/dev/null 2>&1 || launchctl unload "$PLIST" >/dev/null 2>&1 || true
rm -f "$PLIST"

echo "Removed. This does not stop a server that is already running now."
