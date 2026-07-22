#!/bin/bash

# ==========================================================
# InfraPulse Automation Scheduler
# ==========================================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "========================================="
echo "      InfraPulse Automation Started"
echo "========================================="

# Run Alert Manager
echo "[1/4] Running Alert Manager..."
"$BASE_DIR/notifications/alert_manager.sh"

# Generate Reports
echo "[2/4] Generating Reports..."
"$BASE_DIR/reports/generate_html.sh"
"$BASE_DIR/reports/generate_json.sh"
"$BASE_DIR/reports/generate_csv.sh"

# Archive Reports
echo "[3/4] Archiving Reports..."
"$BASE_DIR/reports/historical_reports.sh"

# Cleanup Old Reports
echo "[4/4] Cleaning Old Reports..."
"$BASE_DIR/reports/cleanup_reports.sh"

echo "========================================="
echo " InfraPulse Automation Completed"
echo "========================================="
