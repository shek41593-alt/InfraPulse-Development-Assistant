#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

MONITOR_DIR="$ROOT_DIR/monitoring"

REPORT_DIR="$ROOT_DIR/reports/latest"

mkdir -p "$REPORT_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

SUMMARY="$REPORT_DIR/summary_$TIMESTAMP.txt"

MODULES=(
cpu
memory
disk
network
apache
tomcat
mariadb
docker
security
logs
)

echo "===========================================" > "$SUMMARY"
echo "InfraPulse Monitoring Report" >> "$SUMMARY"
echo "Generated : $(date)" >> "$SUMMARY"
echo "===========================================" >> "$SUMMARY"
echo >> "$SUMMARY"

PASS=0
FAIL=0

for module in "${MODULES[@]}"
do

    SCRIPT="$MONITOR_DIR/$module.sh"

    echo "Running $module..."

    if [[ ! -x "$SCRIPT" ]]; then

        echo "[ERROR] $module missing" | tee -a "$SUMMARY"

        ((++FAIL))

        continue

    fi

    OUTPUT="$REPORT_DIR/${module}_$TIMESTAMP.log"

    if "$SCRIPT" > "$OUTPUT" 2>&1
    then

        echo "[OK] $module" | tee -a "$SUMMARY"

        ((++PASS))

    else

        echo "[FAILED] $module" | tee -a "$SUMMARY"

        ((FAIL++))

    fi

done

echo >> "$SUMMARY"

echo "Successful Modules : $PASS" >> "$SUMMARY"

echo "Failed Modules     : $FAIL" >> "$SUMMARY"

echo >> "$SUMMARY"

if (( FAIL == 0 ))
then
    echo "Overall Health : HEALTHY" >> "$SUMMARY"
else
    echo "Overall Health : WARNING" >> "$SUMMARY"
fi

echo

cat "$SUMMARY"

echo

echo "Reports stored in"

echo "$REPORT_DIR"
