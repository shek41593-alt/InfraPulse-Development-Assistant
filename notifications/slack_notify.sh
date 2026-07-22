#!/usr/bin/env bash

###############################################################################
# InfraPulse Slack Notification
###############################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$ROOT_DIR/config/slack.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Slack configuration not found."
    exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG_FILE"

MESSAGE="${1:-InfraPulse Alert}"

PAYLOAD=$(printf '{"text":"%s"}' "$MESSAGE")

curl -fsS \
    -X POST \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" \
    "$SLACK_WEBHOOK_URL" >/dev/null

echo "Slack notification sent."
