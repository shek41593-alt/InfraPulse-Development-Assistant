#!/usr/bin/env bash

set -euo pipefail

# ==========================================
# InfraPulse Network Monitoring Module
# ==========================================

hostname_name=$(hostname)

fqdn=$(hostname -f 2>/dev/null || echo "Not Configured")

primary_ip=$(hostname -I | awk '{print $1}')

default_gateway=$(ip route | awk '/default/ {print $3}')

interface=$(ip route | awk '/default/ {print $5}')

dns_servers=$(grep "^nameserver" /etc/resolv.conf | awk '{print $2}' | paste -sd ", " -)

internet_status="DISCONNECTED"
latency="N/A"

if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
    internet_status="CONNECTED"

    latency=$(ping -c 3 8.8.8.8 | awk -F'/' '/^rtt/ {print $5 " ms"}')
fi

echo "=================================================="
echo "              NETWORK INFORMATION"
echo "=================================================="
echo

printf "%-20s : %s\n" "Hostname" "$hostname_name"
printf "%-20s : %s\n" "FQDN" "$fqdn"
printf "%-20s : %s\n" "Interface" "$interface"
printf "%-20s : %s\n" "IP Address" "$primary_ip"
printf "%-20s : %s\n" "Gateway" "$default_gateway"
printf "%-20s : %s\n" "DNS Servers" "$dns_servers"
printf "%-20s : %s\n" "Internet" "$internet_status"
printf "%-20s : %s\n" "Latency" "$latency"

echo

if [ "$internet_status" = "CONNECTED" ]; then
    echo "Status : HEALTHY"
else
    echo "Status : CRITICAL"
fi

echo
