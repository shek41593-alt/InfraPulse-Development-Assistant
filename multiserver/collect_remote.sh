#!/bin/bash

# ==========================================================
# InfraPulse Multi-Server Collector
# ==========================================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_FILE="$BASE_DIR/multiserver/servers.conf"
OUTPUT_FILE="$BASE_DIR/reports/remote_servers_report.txt"

mkdir -p "$BASE_DIR/reports"

echo "==========================================" > "$OUTPUT_FILE"
echo "     InfraPulse Remote Monitoring Report" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "==========================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

if [[ ! -f "$SERVER_FILE" ]]; then
    echo "Server inventory not found!"
    exit 1
fi

while IFS="|" read -r HOST IP USER
do
    # Skip blank lines and comments
    [[ -z "$HOST" || "$HOST" =~ ^# ]] && continue

    echo "Monitoring $HOST ($IP)..."

    {
        echo "==========================================="
        echo "Host : $HOST"
        echo "IP   : $IP"
        echo "==========================================="

        "$BASE_DIR/multiserver/monitor_remote.sh" "$IP" "$USER"

        echo ""
    } >> "$OUTPUT_FILE"

done < "$SERVER_FILE"

echo
echo "Remote monitoring completed."
echo "Report saved to:"
echo "$OUTPUT_FILE"
