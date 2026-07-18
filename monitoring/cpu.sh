#!/usr/bin/env bash

set -euo pipefail

# ==========================================
# InfraPulse CPU Monitoring Module
# ==========================================

get_cpu_usage() {
    # Read CPU stats twice to calculate usage
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle1=$((idle + iowait))

    sleep 1

    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle2=$((idle + iowait))

    total_diff=$((total2 - total1))
    idle_diff=$((idle2 - idle1))

    usage=$(( (100 * (total_diff - idle_diff)) / total_diff ))

    echo "$usage"
}

cpu_model=$(grep -m1 "model name" /proc/cpuinfo | cut -d':' -f2 | xargs)
cpu_cores=$(nproc)
architecture=$(uname -m)
kernel=$(uname -r)
hostname=$(hostname)

load_avg=$(awk '{print $1" "$2" "$3}' /proc/loadavg)

cpu_usage=$(get_cpu_usage)

echo "=========================================="
echo "           CPU INFORMATION"
echo "=========================================="
echo

printf "%-20s : %s\n" "Hostname" "$hostname"
printf "%-20s : %s\n" "Kernel" "$kernel"
printf "%-20s : %s\n" "Architecture" "$architecture"
printf "%-20s : %s\n" "CPU Model" "$cpu_model"
printf "%-20s : %s\n" "CPU Cores" "$cpu_cores"
printf "%-20s : %s\n" "Load Average" "$load_avg"
printf "%-20s : %s%%\n" "CPU Usage" "$cpu_usage"

echo

if [ "$cpu_usage" -lt 70 ]; then
    echo "Status : HEALTHY"
elif [ "$cpu_usage" -lt 90 ]; then
    echo "Status : WARNING"
else
    echo "Status : CRITICAL"
fi

echo
