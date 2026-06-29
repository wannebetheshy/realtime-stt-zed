#!/usr/bin/env bash
# Запускает STT сервер в отдельной сессии (отвязан от Zed)
# Zed держит этот процесс как "language server", реальный сервер живёт независимо

SERVER_DIR="$(cd "$(dirname "$0")/server" && pwd)"
VENV_DIR="${SERVER_DIR}/.venv"
SETTINGS_PATH="${SERVER_DIR}/settings.yaml"
LOGFILE="/tmp/realtime-stt.log"

# Проверяем не запущен ли уже сервер
if curl -sf http://127.0.0.1:8765/health > /dev/null 2>&1; then
    echo "[realtime-stt] server already running" >&2
else
    echo "[realtime-stt] starting server in background..." >&2
    # setsid отвязывает процесс от нашей группы — выживет даже если Zed нас убьёт
    setsid env \
        VENV_DIR="$VENV_DIR" \
        SETTINGS_PATH="$SETTINGS_PATH" \
        bash "${SERVER_DIR}/setup.sh" > "$LOGFILE" 2>&1 &
    echo "[realtime-stt] server pid: $! , logs: $LOGFILE" >&2
fi

# Держим Zed живым
exec sleep infinity
