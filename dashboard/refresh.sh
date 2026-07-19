#!/usr/bin/env bash

###############################################################################
# InfraPulse Dashboard Auto Refresh
###############################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DASHBOARD="$ROOT_DIR/dashboard/dashboard.sh"

INTERVAL="${1:-5}"

while true
do
    clear

    bash "$DASHBOARD"

    echo
    echo "Refreshing every ${INTERVAL} seconds... (Press Ctrl+C to exit)"

    sleep "$INTERVAL"
done
