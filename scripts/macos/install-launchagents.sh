#!/bin/bash
# Installiert LaunchAgents: Server (KeepAlive) + Healthcheck-Watchdog (alle 60s).
set -e
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
AGENTS="$HOME/Library/LaunchAgents"
mkdir -p "$AGENTS"
chmod +x "$ROOT"/scripts/macos/*.sh

cat > "$AGENTS/com.jarvis.server.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>com.jarvis.server</string>
  <key>ProgramArguments</key><array><string>$ROOT/scripts/macos/run-server.sh</string></array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <key>ProcessType</key><string>Interactive</string>
  <key>StandardOutPath</key><string>/tmp/jarvis-server.log</string>
  <key>StandardErrorPath</key><string>/tmp/jarvis-server.log</string>
</dict></plist>
PLIST

cat > "$AGENTS/com.jarvis.health.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>com.jarvis.health</string>
  <key>ProgramArguments</key><array><string>$ROOT/scripts/macos/healthcheck.sh</string></array>
  <key>StartInterval</key><integer>60</integer>
  <key>RunAtLoad</key><true/>
</dict></plist>
PLIST

for l in com.jarvis.server com.jarvis.health; do
  launchctl bootout "gui/$(id -u)/$l" 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$AGENTS/$l.plist"
done

defaults write NSGlobalDomain NSAppSleepDisabled -bool YES
echo "Fertig. Logs: /tmp/jarvis-server.log, /tmp/jarvis-health.log"
