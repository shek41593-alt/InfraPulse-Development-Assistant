#!/bin/bash

# ==========================================================
# InfraPulse Docker Entrypoint
# ==========================================================

set -e

APP_DIR="/opt/infrapulse"

echo "=============================================="
echo "        Starting InfraPulse Container"
echo "=============================================="

cd "$APP_DIR"

# ----------------------------------------------------------
# Create required directories
# ----------------------------------------------------------

mkdir -p logs
mkdir -p reports
mkdir -p reports/archive
mkdir -p config

# ----------------------------------------------------------
# Make scripts executable
# ----------------------------------------------------------

find monitoring -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find dashboard -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find reports -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find notifications -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find automation -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find multiserver -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# ----------------------------------------------------------
# Start cron service (if available)
# ----------------------------------------------------------

if command -v service >/dev/null 2>&1; then
    service cron start >/dev/null 2>&1 || true
fi

echo
echo "InfraPulse is ready."
echo

# ----------------------------------------------------------
# Execute the container command
# ----------------------------------------------------------

exec "$@"
