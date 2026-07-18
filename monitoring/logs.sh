#!/usr/bin/env bash

set -uo pipefail

# ==========================================
# InfraPulse Log Analyzer
# ==========================================

echo "======================================================="
echo "              LOG ANALYZER REPORT"
echo "======================================================="
echo

count_lines() {
    if command -v journalctl >/dev/null 2>&1; then
        journalctl "$@" 2>/dev/null | wc -l
    else
        echo 0
    fi
}

#########################################
# System Errors
#########################################

system_errors=$(count_lines -p err --since "24 hours ago")

#########################################
# SSH Failures
#########################################

ssh_failures=$(
journalctl --since "24 hours ago" 2>/dev/null \
| grep -ic "Failed password" || true
)

#########################################
# Apache Errors
#########################################

apache_errors=0

if systemctl list-unit-files 2>/dev/null | grep -qE "^apache2.service|^httpd.service"; then

    apache_errors=$(
    journalctl -u apache2 -u httpd \
    --since "24 hours ago" 2>/dev/null \
    | grep -ic "error" || true
    )
fi

#########################################
# Tomcat Errors
#########################################

tomcat_errors=0

for svc in tomcat tomcat9 tomcat10; do

    if systemctl list-unit-files 2>/dev/null | grep -q "^${svc}.service"; then

        tomcat_errors=$(
        journalctl -u "$svc" \
        --since "24 hours ago" \
        2>/dev/null \
        | grep -ic "error" || true
        )

        break
    fi

done

#########################################
# Docker Errors
#########################################

docker_errors=0

if systemctl list-unit-files 2>/dev/null | grep -q "^docker.service"; then

    docker_errors=$(
    journalctl -u docker \
    --since "24 hours ago" \
    2>/dev/null \
    | grep -ic "error" || true
    )

fi

#########################################
# MariaDB Errors
#########################################

db_errors=0

for svc in mariadb mysql mysqld; do

    if systemctl list-unit-files 2>/dev/null | grep -q "^${svc}.service"; then

        db_errors=$(
        journalctl -u "$svc" \
        --since "24 hours ago" \
        2>/dev/null \
        | grep -ic "error" || true
        )

        break
    fi

done

#########################################
# Disk Errors
#########################################

disk_errors=$(
journalctl -k \
--since "24 hours ago" \
2>/dev/null \
| grep -Ei "I/O error|filesystem|EXT4-fs|XFS" \
| wc -l || true
)

#########################################
# Output
#########################################

printf "%-30s : %s\n" "System Errors" "$system_errors"
printf "%-30s : %s\n" "SSH Authentication Failures" "$ssh_failures"
printf "%-30s : %s\n" "Apache Errors" "$apache_errors"
printf "%-30s : %s\n" "Tomcat Errors" "$tomcat_errors"
printf "%-30s : %s\n" "Docker Errors" "$docker_errors"
printf "%-30s : %s\n" "MariaDB Errors" "$db_errors"
printf "%-30s : %s\n" "Disk/Filesystem Errors" "$disk_errors"

total=$((system_errors + ssh_failures + apache_errors + tomcat_errors + docker_errors + db_errors + disk_errors))

echo
echo "-----------------------------------------------"

printf "%-30s : %s\n" "Total Findings" "$total"

echo

if (( total == 0 )); then
    echo "Overall Log Health : HEALTHY"
elif (( total < 20 )); then
    echo "Overall Log Health : WARNING"
else
    echo "Overall Log Health : CRITICAL"
fi

echo
