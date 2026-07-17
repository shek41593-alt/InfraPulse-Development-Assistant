#!/usr/bin/env bash

set -euo pipefail

# ==========================================
# InfraPulse Memory Monitoring Module
# ==========================================

get_memory_info() {

    total=$(free -m | awk '/^Mem:/ {print $2}')
    used=$(free -m | awk '/^Mem:/ {print $3}')
    free_mem=$(free -m | awk '/^Mem:/ {print $4}')
    available=$(free -m | awk '/^Mem:/ {print $7}')

    usage=$(( used * 100 / total ))

    echo "========================================="
    echo "        MEMORY UTILIZATION"
    echo "========================================="
    echo

    printf "%-20s : %s MB\n" "Total Memory" "$total"
    printf "%-20s : %s MB\n" "Used Memory" "$used"
    printf "%-20s : %s MB\n" "Free Memory" "$free_mem"
    printf "%-20s : %s MB\n" "Available Memory" "$available"
    printf "%-20s : %s%%\n" "Usage" "$usage"

    echo

    if [ "$usage" -lt 70 ]; then
        echo "Status : HEALTHY"
    elif [ "$usage" -lt 90 ]; then
        echo "Status : WARNING"
    else
        echo "Status : CRITICAL"
    fi

    echo
}

get_memory_info
