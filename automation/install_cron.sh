#!/bin/bash

# ==========================================================
# InfraPulse Cron Installer
# ==========================================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CRON_JOB="*/5 * * * * $BASE_DIR/automation/scheduler.sh >/dev/null 2>&1"

echo "Installing InfraPulse cron job..."

(
    crontab -l 2>/dev/null | grep -v "$BASE_DIR/automation/scheduler.sh"
    echo "$CRON_JOB"
) | crontab -

echo
echo "Cron job installed successfully!"
echo
echo "Current cron jobs:"
crontab -l
