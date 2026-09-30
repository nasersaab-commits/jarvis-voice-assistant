#!/bin/bash
# Startet den Jarvis-Server und verhindert System-Sleep, solange er laeuft.
cd "$(dirname "$0")/../.." || exit 1
exec /usr/bin/caffeinate -dimsu python3 server.py
