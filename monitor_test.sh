#!/usr/bin/env bash

LOGFILE="${LOGFILE:-/var/log/monitoring.log}"
STATEFILE="${STATEFILE:-/var/run/monitor_test.state}"
PROCESS="${PROCESS_NAME:-test}"
URL="${API_URL:-https://test.com/monitoring/test/api}"

pgrep -f "$PROCESS" &>/dev/null && curr=1 || curr=0
prev=0; [[ -f "$STATEFILE" ]] && prev=$(<"$STATEFILE")

# Проверяем состояние процесса предыдущего и текущего запуска
if [[ $prev -eq 0 && $curr -eq 1 ]]; then
    echo "$(date +'%F %T') INFO: '$PROCESS' started" >> "$LOGFILE"
elif [[ $prev -eq 1 && $curr -eq 0 ]]; then
    echo "$(date +'%F %T') INFO: '$PROCESS' stopped" >> "$LOGFILE"
elif [[ $prev -eq 1 && $curr -eq 1 ]]; then # Если процесс перезапустился
    curr_pid=$(pgrep -f "$PROCESS")
    prev_pid=0
    [[ -f "${STATEFILE}.pid" ]] && prev_pid=$(<"${STATEFILE}.pid")
    
    if [[ "$curr_pid" != "$prev_pid" ]]; then
        echo "$(date +'%F %T') INFO: '$PROCESS' restarted" >> "$LOGFILE"
    fi
    echo "$curr_pid" > "${STATEFILE}.pid"
fi

# Проверяем доступность апишки
if [[ $curr -eq 1 ]]; then
    curl -s --head "$URL" &>/dev/null || \
        echo "$(date +'%F %T') ERROR: API not reachable" >> "$LOGFILE"
fi

echo "$curr" > "$STATEFILE"