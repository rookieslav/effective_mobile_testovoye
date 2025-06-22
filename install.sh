#!/usr/bin/env bash
set -e

BIN_PATH="/usr/local/bin/monitor_test.sh"
SERVICE_PATH="/etc/systemd/system/monitor_test.service"
TIMER_PATH="/etc/systemd/system/monitor_test.timer"
ENV_FILE="/etc/monitor_test.env"
ART_DST="./art.txt"

cat "$ART_DST"
echo "[+] Установка мониторинга тестового процесса"

sudo cp monitor_test.sh "$BIN_PATH"
sudo chmod +x "$BIN_PATH"

sudo tee "$SERVICE_PATH" > /dev/null <<EOF
[Unit]
Description=Monitor test process
[Service]
Type=oneshot
EnvironmentFile=-$ENV_FILE
ExecStart=$BIN_PATH
EOF

sudo tee "$TIMER_PATH" > /dev/null <<EOF
[Unit]
Description=Run monitor_test every minute
[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
[Install]
WantedBy=timers.target
EOF

if [[ ! -f "$ENV_FILE" ]]; then
  sudo tee "$ENV_FILE" > /dev/null <<EOF
LOGFILE=/var/log/monitoring.log
STATEFILE=/var/run/monitor_test.state
PROCESS_NAME=test
API_URL=https://test.com/monitoring/test/api
EOF
fi

sudo systemctl daemon-reload
sudo systemctl enable --now monitor_test.timer

echo "[✓] Установка завершена. Мониторинг запущен."
