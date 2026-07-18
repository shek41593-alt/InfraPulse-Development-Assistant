#!/usr/bin/env bash

set -euo pipefail

# ==========================================
# InfraPulse MariaDB/MySQL Monitoring Module
# ==========================================

SERVICE=""

# Detect installed database service
for candidate in mariadb mysql mysqld; do
    if systemctl list-unit-files | grep -q "^${candidate}\.service"; then
        SERVICE="$candidate"
        break
    fi
done

if [[ -z "$SERVICE" ]]; then
    echo "MariaDB/MySQL is not installed."
    exit 1
fi

status=$(systemctl is-active "$SERVICE")
enabled=$(systemctl is-enabled "$SERVICE" 2>/dev/null || echo "disabled")
pid=$(systemctl show -p MainPID "$SERVICE" | cut -d= -f2)

version="Unavailable"
if command -v mysql >/dev/null 2>&1; then
    version=$(mysql --version)
fi

ports=$(ss -ltnp 2>/dev/null | grep -E "3306|mysqld" | awk '{print $4}' | paste -sd "," -)

connection="FAILED"
uptime="Unavailable"

if command -v mysqladmin >/dev/null 2>&1; then
    if mysqladmin ping >/dev/null 2>&1; then
        connection="SUCCESS"

        uptime=$(mysqladmin status 2>/dev/null | sed 's/^.*Uptime: \([0-9]*\).*$/\1 seconds/' || echo "Unavailable")
    fi
fi

echo "================================================"
echo "          DATABASE SERVICE MONITOR"
echo "================================================"
echo

printf "%-20s : %s\n" "Service" "$SERVICE"
printf "%-20s : %s\n" "Status" "$status"
printf "%-20s : %s\n" "Enabled" "$enabled"
printf "%-20s : %s\n" "Main PID" "$pid"
printf "%-20s : %s\n" "Version" "$version"
printf "%-20s : %s\n" "Ports" "${ports:-None}"
printf "%-20s : %s\n" "Connectivity" "$connection"
printf "%-20s : %s\n" "Uptime" "$uptime"

echo

if [[ "$status" == "active" && "$connection" == "SUCCESS" ]]; then
    echo "Overall Health : HEALTHY"
elif [[ "$status" == "active" ]]; then
    echo "Overall Health : WARNING"
else
    echo "Overall Health : CRITICAL"
fi

echo
