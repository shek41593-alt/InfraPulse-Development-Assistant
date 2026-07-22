#!/usr/bin/env bash

set -euo pipefail

# ==========================================
# InfraPulse Disk Monitoring Module
# ==========================================


echo "=============================================================="
echo "                    DISK UTILIZATION"
echo "=============================================================="
printf "%-20s %-8s %-8s %-8s %-6s %-12s %s\n" \
"Filesystem" "Size" "Used" "Avail" "Use%" "Status" "Mounted On"
echo "--------------------------------------------------------------"

df -hP | awk 'NR>1 {
    gsub("%","",$5)

    status="HEALTHY"

    if($5>=90)
        status="CRITICAL"
    else if($5>=80)
        status="WARNING"

    printf "%-20s %-8s %-8s %-8s %-6s %-12s %s\n",
           $1,$2,$3,$4,$5"%",status,$6
}'
