#!/bin/bash

# ==========================================================
# InfraPulse Alert Manager
# ==========================================================

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$BASE_DIR/config/alerts.conf"

# shellcheck source=/dev/null
source "$CONFIG_FILE"

CPU_SCRIPT="$BASE_DIR/monitoring/cpu_monitor.sh"
MEMORY_SCRIPT="$BASE_DIR/monitoring/memory_monitor.sh"
DISK_SCRIPT="$BASE_DIR/monitoring/disk_monitor.sh"

SLACK_SCRIPT="$BASE_DIR/notifications/slack_notify.sh"
DISCORD_SCRIPT="$BASE_DIR/notifications/discord_notify.sh"
TELEGRAM_SCRIPT="$BASE_DIR/notifications/telegram_notify.sh"
EMAIL_SCRIPT="$BASE_DIR/notifications/send_email.sh"

# ==========================================================
# Collect Metrics
# ==========================================================

CPU_USAGE="$("$CPU_SCRIPT")"
MEMORY_USAGE="$("$MEMORY_SCRIPT")"
DISK_USAGE="$("$DISK_SCRIPT")"

echo "========================================="
echo "         InfraPulse Alert Manager"
echo "========================================="
echo "CPU Usage    : ${CPU_USAGE}%"
echo "Memory Usage : ${MEMORY_USAGE}%"
echo "Disk Usage   : ${DISK_USAGE}%"
echo

# ==========================================================
# Send Notifications
# ==========================================================

send_alert() {

    local message="$1"

    echo "ALERT: $message"

    if [[ "${SLACK_ENABLED}" == "true" && -x "$SLACK_SCRIPT" ]]; then
        "$SLACK_SCRIPT" "$message"
    fi

    if [[ "${DISCORD_ENABLED}" == "true" && -x "$DISCORD_SCRIPT" ]]; then
        "$DISCORD_SCRIPT" "$message"
    fi

    if [[ "${TELEGRAM_ENABLED}" == "true" && -x "$TELEGRAM_SCRIPT" ]]; then
        "$TELEGRAM_SCRIPT" "$message"
    fi

    if [[ "${EMAIL_ENABLED}" == "true" && -x "$EMAIL_SCRIPT" ]]; then
        "$EMAIL_SCRIPT" "$message"
    fi
}

# ==========================================================
# Threshold Checks
# ==========================================================

if (( CPU_USAGE >= CPU_THRESHOLD )); then
    send_alert "CPU usage is ${CPU_USAGE}% (Threshold: ${CPU_THRESHOLD}%)"
fi

if (( MEMORY_USAGE >= MEMORY_THRESHOLD )); then
    send_alert "Memory usage is ${MEMORY_USAGE}% (Threshold: ${MEMORY_THRESHOLD}%)"
fi

if (( DISK_USAGE >= DISK_THRESHOLD )); then
    send_alert "Disk usage is ${DISK_USAGE}% (Threshold: ${DISK_THRESHOLD}%)"
fi

echo
echo "Alert check completed."
