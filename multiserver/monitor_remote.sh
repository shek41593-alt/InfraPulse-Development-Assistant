#!/bin/bash

# ==========================================================
# InfraPulse Remote Server Monitor
# ==========================================================

SERVER="$1"
USER="$2"

if [[ -z "$SERVER" || -z "$USER" ]]; then
    echo "Usage:"
    echo "./monitor_remote.sh <server-ip> <username>"
    exit 1
fi

echo "==========================================="
echo "Monitoring Server : $SERVER"
echo "==========================================="

ssh -o ConnectTimeout=5 "${USER}@${SERVER}" << 'EOF'

echo "Hostname : $(hostname)"
echo "Operating System : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
echo "Kernel : $(uname -r)"

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2+$4)}')
echo "CPU Usage : ${CPU}%"

MEM=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 *100}')
echo "Memory Usage : ${MEM}%"

DISK=$(df / | awk 'NR==2 {gsub("%","");print $5}')
echo "Disk Usage : ${DISK}%"

echo "Uptime : $(uptime -p)"

EOF
