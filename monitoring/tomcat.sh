#!/usr/bin/env bash

set -euo pipefail

# ==========================================
# InfraPulse Tomcat Monitoring Module
# ==========================================

SERVICE=""

# Detect common Tomcat service names
for candidate in tomcat tomcat9 tomcat10 tomcat10.service tomcat9.service; do
    name="${candidate%.service}"
    if systemctl list-unit-files | grep -q "^${name}\.service"; then
        SERVICE="$name"
        break
    fi
done

if [[ -z "$SERVICE" ]]; then
    echo "Tomcat is not installed."
    exit 1
fi

status=$(systemctl is-active "$SERVICE")
enabled=$(systemctl is-enabled "$SERVICE" 2>/dev/null || echo "disabled")
pid=$(systemctl show -p MainPID "$SERVICE" | cut -d= -f2)

# Detect listening ports
ports=$(ss -ltnp 2>/dev/null | grep java | awk '{print $4}' | paste -sd "," -)

# Detect Java process
java_process=$(pgrep -af "org.apache.catalina.startup.Bootstrap" || true)

# Try common connector ports
http_port=""
for p in 8080 8081 8082 8083 8084 8085 8086 8087 8088 8089; do
    if curl -s --max-time 2 "http://localhost:${p}" >/dev/null 2>&1; then
        http_port="$p"
        break
    fi
done

http_status="FAILED"

if [[ -n "$http_port" ]]; then
    http_status="SUCCESS"
fi

echo "==============================================="
echo "           TOMCAT SERVICE MONITOR"
echo "==============================================="
echo

printf "%-20s : %s\n" "Service" "$SERVICE"
printf "%-20s : %s\n" "Status" "$status"
printf "%-20s : %s\n" "Enabled" "$enabled"
printf "%-20s : %s\n" "Main PID" "$pid"
printf "%-20s : %s\n" "Java Process" "${java_process:-Not Found}"
printf "%-20s : %s\n" "Ports" "${ports:-None}"
printf "%-20s : %s\n" "HTTP Port" "${http_port:-Not Found}"
printf "%-20s : %s\n" "HTTP Response" "$http_status"

echo

if [[ "$status" == "active" && "$http_status" == "SUCCESS" ]]; then
    echo "Overall Health : HEALTHY"
else
    echo "Overall Health : WARNING"
fi

echo
