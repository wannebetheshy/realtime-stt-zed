#!/usr/bin/env bash
SERVER_DIR="$(cd "$(dirname "$0")/server" && pwd)"
VENV_DIR="${SERVER_DIR}/.venv"
SETTINGS_PATH="${SERVER_DIR}/settings.yaml"
LOGFILE="/tmp/realtime-stt.log"

if curl -sf http://127.0.0.1:8765/health > /dev/null 2>&1; then
    echo "[realtime-stt] server already running" >&2
else
    echo "[realtime-stt] starting server, logs: $LOGFILE" >&2
    nohup env \
        VENV_DIR="$VENV_DIR" \
        SETTINGS_PATH="$SETTINGS_PATH" \
        bash "${SERVER_DIR}/setup.sh" > "$LOGFILE" 2>&1 &
    disown $!
fi

exec sleep infinity
