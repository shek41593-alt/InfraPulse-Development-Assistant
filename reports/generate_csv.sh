#!/usr/bin/env bash

###############################################################################
# InfraPulse CSV Report Generator
###############################################################################

set -euo pipefail

REPORT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_FILE="$REPORT_DIR/infrapulse_report.csv"

HOSTNAME=$(hostname)

OS=$(grep "^PRETTY_NAME=" /etc/os-release | cut -d= -f2 | tr -d '"')

KERNEL=$(uname -r)

CPU=$(top -bn1 | awk '/Cpu\(s\)/ {printf "%.0f",100-$8}')

MEMORY=$(free | awk '/Mem:/ {printf "%.0f",($3/$2)*100}')

DISK=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

UPTIME=$(uptime -p)

DATE=$(date)

if ping -c1 -W1 8.8.8.8 >/dev/null 2>&1
then
    NETWORK="Connected"
else
    NETWORK="Disconnected"
fi

cat > "$REPORT_FILE" <<EOF
Metric,Value
Generated,$DATE
Hostname,$HOSTNAME
Operating System,$OS
Kernel,$KERNEL
Uptime,$UPTIME
CPU Usage (%),$CPU
Memory Usage (%),$MEMORY
Disk Usage (%),$DISK
Network,$NETWORK
EOF

echo "CSV report generated successfully."
echo "Location: $REPORT_FILE"
