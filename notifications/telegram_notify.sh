#!/usr/bin/env bash

###############################################################################
# InfraPulse Telegram Notification
###############################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CONFIG_FILE="$ROOT_DIR/config/telegram.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Telegram configuration not found."
    exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG_FILE"

MESSAGE="${1:-InfraPulse Alert}"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST \
    "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d text="$MESSAGE")

if [[ "$HTTP_CODE" == "200" ]]; then
    echo "Telegram notification sent successfully."
else
    echo "Failed to send Telegram notification. HTTP Status: $HTTP_CODE"
fi
