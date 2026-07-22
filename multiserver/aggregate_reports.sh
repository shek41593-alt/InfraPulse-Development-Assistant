#!/usr/bin/env bash

###############################################################################
# InfraPulse Report Aggregator
###############################################################################

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

LOCAL_JSON="$BASE_DIR/reports/infrapulse_report.json"
LOCAL_CSV="$BASE_DIR/reports/infrapulse_report.csv"
REMOTE_REPORT="$BASE_DIR/reports/remote_servers_report.txt"

OUTPUT="$BASE_DIR/reports/final_system_report.txt"

{
    echo "=========================================="
    echo "        InfraPulse Consolidated Report"
    echo "Generated: $(date)"
    echo "=========================================="
    echo

    # ----------------------------------------------------
    # Local JSON Report
    # ----------------------------------------------------
    if [[ -f "$LOCAL_JSON" ]]; then
        echo "========== LOCAL JSON REPORT =========="
        cat "$LOCAL_JSON"
        echo
    fi

    # ----------------------------------------------------
    # Local CSV Report
    # ----------------------------------------------------
    if [[ -f "$LOCAL_CSV" ]]; then
        echo "========== LOCAL CSV REPORT =========="
        cat "$LOCAL_CSV"
        echo
    fi

    # ----------------------------------------------------
    # Remote Monitoring Report
    # ----------------------------------------------------
    if [[ -f "$REMOTE_REPORT" ]]; then
        echo "====== REMOTE SERVER MONITORING ======"
        cat "$REMOTE_REPORT"
        echo
    fi

    echo "=========================================="
    echo "End of Report"
    echo "=========================================="

} > "$OUTPUT"

echo
echo "Consolidated report created successfully."
echo "Output: $OUTPUT"
