#!/bin/bash

# ==========================================================
# InfraPulse - Alert Manager
# ==========================================================

CONFIG_FILE="config/alerts.conf"

# Load alert configuration
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Alert configuration file not found!"
    exit 1
fi

# -------------------------
# Collect System Metrics
# -------------------------

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2+$4)}')

MEMORY_USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')

DISK_USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

# -------------------------
# Alert Function
# -------------------------

send_alert() {
    MESSAGE="$1"

    echo "[ALERT] $MESSAGE"

    [ "$SLACK_ENABLED" = "true" ] && ./notifications/slack_notify.sh "$MESSAGE"

    [ "$DISCORD_ENABLED" = "true" ] && ./notifications/discord_notify.sh "$MESSAGE"

    [ "$TELEGRAM_ENABLED" = "true" ] && ./notifications/telegram_notify.sh "$MESSAGE"

    [ "$EMAIL_ENABLED" = "true" ] && ./notifications/send_email.sh "$MESSAGE"
}

# -------------------------
# CPU Alert
# -------------------------

if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
    send_alert "🚨 CPU Usage is ${CPU_USAGE}% (Threshold: ${CPU_THRESHOLD}%)"
fi

# -------------------------
# Memory Alert
# -------------------------

if [ "$MEMORY_USAGE" -ge "$MEMORY_THRESHOLD" ]; then
    send_alert "🚨 Memory Usage is ${MEMORY_USAGE}% (Threshold: ${MEMORY_THRESHOLD}%)"
fi

# -------------------------
# Disk Alert
# -------------------------

if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
    send_alert "🚨 Disk Usage is ${DISK_USAGE}% (Threshold: ${DISK_THRESHOLD}%)"
fi

echo "Alert scan completed."
