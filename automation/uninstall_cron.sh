#!/bin/bash

# ==========================================================
# InfraPulse Cron Uninstaller
# ==========================================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Removing InfraPulse cron job..."

crontab -l 2>/dev/null | \
grep -v "$BASE_DIR/automation/scheduler.sh" | \
crontab -

echo
echo "Cron job removed successfully!"
echo
echo "Current cron jobs:"
crontab -l 2>/dev/null || echo "No cron jobs configured."
