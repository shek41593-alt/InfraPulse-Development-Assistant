#!/usr/bin/env bash

###############################################################################
# InfraPulse Discord Notification
###############################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CONFIG_FILE="$ROOT_DIR/config/discord.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Discord configuration not found."
    exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG_FILE"

MESSAGE="${1:-InfraPulse Alert}"

RESPONSE=$(curl -s \
    -H "Content-Type: application/json" \
    -X POST \
    -d "{\"content\":\"$MESSAGE\"}" \
    "$DISCORD_WEBHOOK_URL")

echo "Discord notification sent."
