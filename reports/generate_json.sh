#!/usr/bin/env bash

###############################################################################
# InfraPulse JSON Report Generator
###############################################################################

set -euo pipefail

REPORT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_FILE="$REPORT_DIR/infrapulse_report.json"

HOSTNAME=$(hostname)

OS=$(grep "^PRETTY_NAME=" /etc/os-release | cut -d= -f2 | tr -d '"')

KERNEL=$(uname -r)

CPU=$(top -bn1 | awk '/Cpu\(s\)/ {printf "%.0f",100-$8}')

MEMORY=$(free | awk '/Mem:/ {printf "%.0f",($3/$2)*100}')

DISK=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

UPTIME=$(uptime -p)

DATE=$(date --iso-8601=seconds)

if ping -c1 -W1 8.8.8.8 >/dev/null 2>&1
then
    NETWORK="Connected"
else
    NETWORK="Disconnected"
fi

cat > "$REPORT_FILE" <<EOF
{
    "report": {
        "generated_at": "$DATE",
        "hostname": "$HOSTNAME",
        "operating_system": "$OS",
        "kernel": "$KERNEL",
        "uptime": "$UPTIME",

        "cpu": {
            "usage_percent": $CPU
        },

        "memory": {
            "usage_percent": $MEMORY
        },

        "disk": {
            "usage_percent": $DISK
        },

        "network": {
            "status": "$NETWORK"
        }
    }
}
EOF

echo "JSON report generated successfully."
echo "Location: $REPORT_FILE"
