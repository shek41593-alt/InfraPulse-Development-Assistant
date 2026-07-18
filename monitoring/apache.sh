#!/usr/bin/env bash

set -euo pipefail

# ==========================================
# InfraPulse Apache Monitoring Module
# ==========================================

SERVICE=""

# Detect Apache service
if systemctl list-unit-files | grep -q "^httpd.service"; then
    SERVICE="httpd"
elif systemctl list-unit-files | grep -q "^apache2.service"; then
    SERVICE="apache2"
else
    echo "Apache is not installed."
    exit 1
fi

echo "==============================================="
echo "         APACHE SERVICE MONITOR"
echo "==============================================="
echo

# Service Status
status=$(systemctl is-active "$SERVICE")

# Enabled
enabled=$(systemctl is-enabled "$SERVICE" 2>/dev/null || echo "disabled")

# PID
pid=$(systemctl show -p MainPID "$SERVICE" | cut -d= -f2)

# Version
version=$(apachectl -v 2>/dev/null | head -1 || true)

# Config Test
config=$(apachectl configtest 2>/dev/null | tail -1 || echo "Unavailable")

# Listening Ports
ports=$(ss -tulpn | grep "$SERVICE" | awk '{print $5}' | paste -sd "," -)

# HTTP Check
http_status="FAILED"

if curl -I -s http://localhost >/dev/null; then
    http_status="SUCCESS"
fi

printf "%-20s : %s\n" "Service" "$SERVICE"
printf "%-20s : %s\n" "Status" "$status"
printf "%-20s : %s\n" "Enabled" "$enabled"
printf "%-20s : %s\n" "Main PID" "$pid"
printf "%-20s : %s\n" "Version" "$version"
printf "%-20s : %s\n" "Config Test" "$config"
printf "%-20s : %s\n" "Ports" "${ports:-None}"
printf "%-20s : %s\n" "HTTP Response" "$http_status"

echo

if [[ "$status" == "active" && "$http_status" == "SUCCESS" ]]; then
    echo "Overall Health : HEALTHY"
else
    echo "Overall Health : CRITICAL"
fi

echo
