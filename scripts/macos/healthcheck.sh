#!/bin/bash
# Watchdog: prueft /health und startet den Server-LaunchAgent bei Ausfall neu.
# Wird per LaunchAgent jede Minute ausgefuehrt (auch nach Wake).
LABEL="com.jarvis.server"
if ! curl -fsS --max-time 5 http://localhost:8340/health >/dev/null; then
    echo "$(date) Jarvis nicht erreichbar - Neustart" >> /tmp/jarvis-health.log
    launchctl kickstart -k "gui/$(id -u)/$LABEL"
fi
