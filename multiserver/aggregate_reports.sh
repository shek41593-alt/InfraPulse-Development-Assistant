#!/bin/bash

# ==========================================================
# InfraPulse Report Aggregator
# ==========================================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

LOCAL_JSON="$BASE_DIR/reports/infrapulse_report.json"
LOCAL_CSV="$BASE_DIR/reports/infrapulse_report.csv"
LOCAL_HTML="$BASE_DIR/reports/infrapulse_report.html"
REMOTE_REPORT="$BASE_DIR/reports/remote_servers_report.txt"

OUTPUT="$BASE_DIR/reports/final_system_report.txt"

echo "==========================================" > "$OUTPUT"
echo "        InfraPulse Consolidated Report" >> "$OUTPUT"
echo "Generated: $(date)" >> "$OUTPUT"
echo "==========================================" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# ----------------------------------------------------
# Local JSON Report
# ----------------------------------------------------

if [ -f "$LOCAL_JSON" ]; then
    echo "========== LOCAL JSON REPORT ==========" >> "$OUTPUT"
    cat "$LOCAL_JSON" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
fi

# ----------------------------------------------------
# Local CSV Report
# ----------------------------------------------------

if [ -f "$LOCAL_CSV" ]; then
    echo "========== LOCAL CSV REPORT ===========" >> "$OUTPUT"
    cat "$LOCAL_CSV" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
fi

# ----------------------------------------------------
# Remote Monitoring Report
# ----------------------------------------------------

if [ -f "$REMOTE_REPORT" ]; then
    echo "====== REMOTE SERVER MONITORING =======" >> "$OUTPUT"
    cat "$REMOTE_REPORT" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
fi

echo "==========================================" >> "$OUTPUT"
echo "End of Report" >> "$OUTPUT"
echo "==========================================" >> "$OUTPUT"

echo
echo "Consolidated report created:"
echo "$OUTPUT"
