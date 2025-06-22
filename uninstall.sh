#!/usr/bin/env bash
set -e

BIN_PATH="/usr/local/bin/monitor_test.sh"
SERVICE_PATH="/etc/systemd/system/monitor_test.service"
TIMER_PATH="/etc/systemd/system/monitor_test.timer"
ENV_FILE="/etc/monitor_test.env"
LOGFILE="/var/log/monitoring.log"
STATEFILE="/var/run/monitor_test.state"

# Останавливаем и отключаем таймер
sudo systemctl stop monitor_test.timer || true
sudo systemctl disable monitor_test.timer || true

# Останавливаем сервис
sudo systemctl stop monitor_test.service || true

# Перезагружаем демона
echo "[+] Перезагружаем systemd"
sudo systemctl daemon-reload

# Удаляем файлы
sudo rm -f "$BIN_PATH"
sudo rm -f "$SERVICE_PATH" "$TIMER_PATH"
sudo rm -f "$ENV_FILE"
sudo rm -f "$LOGFILE" "$STATEFILE"

# Перезагружаем демона ещё раз
echo "[+] Перезагружаем systemd после удаления"
sudo systemctl daemon-reload

echo "[✓] Удаление завершено. Все компоненты удалены."