#!/usr/bin/env bash

set -euo pipefail

# ==========================================
# InfraPulse Docker Monitoring Module
# ==========================================

echo "==============================================="
echo "          DOCKER SERVICE MONITOR"
echo "==============================================="
echo

# Check Docker installation
if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is not installed."
    exit 1
fi

status=$(systemctl is-active docker 2>/dev/null || echo "inactive")
enabled=$(systemctl is-enabled docker 2>/dev/null || echo "disabled")
pid=$(systemctl show -p MainPID docker 2>/dev/null | cut -d= -f2)

version=$(docker --version)

running=$(docker ps -q | wc -l)
stopped=$(docker ps -aq --filter status=exited | wc -l)

images=$(docker images -q | sort -u | wc -l)

volumes=$(docker volume ls -q | wc -l)

networks=$(docker network ls --format "{{.Name}}" | wc -l)

disk_usage=$(docker system df 2>/dev/null)

unhealthy=$(
docker ps \
--filter health=unhealthy \
-q | wc -l
)

echo "Service Status      : $status"
echo "Enabled             : $enabled"
echo "Main PID            : $pid"
echo "Docker Version      : $version"

echo
echo "Container Statistics"
echo "--------------------"

echo "Running Containers  : $running"
echo "Stopped Containers  : $stopped"
echo "Unhealthy           : $unhealthy"

echo
echo "Resources"
echo "---------"

echo "Images              : $images"
echo "Volumes             : $volumes"
echo "Networks            : $networks"

echo
echo "Docker Disk Usage"
echo "-----------------"
echo "$disk_usage"

echo

if [[ "$status" != "active" ]]; then
    echo "Overall Health : CRITICAL"

elif [[ "$unhealthy" -gt 0 ]]; then
    echo "Overall Health : WARNING"

else
    echo "Overall Health : HEALTHY"
fi

echo
