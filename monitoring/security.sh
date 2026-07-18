#!/usr/bin/env bash

set -euo pipefail

# ==========================================
# InfraPulse Security Audit Module
# ==========================================

echo "================================================"
echo "           SECURITY AUDIT REPORT"
echo "================================================"
echo

score=0
max_score=4

SSHD_CONFIG="/etc/ssh/sshd_config"

##############################################
# SSH Configuration
##############################################

root_login="Default"
password_auth="Default"

if [[ -f "$SSHD_CONFIG" ]]; then

    root_login=$(
        awk '/^[[:space:]]*PermitRootLogin[[:space:]]+/ {print $2}' \
        "$SSHD_CONFIG" 2>/dev/null | tail -1
    )

    password_auth=$(
        awk '/^[[:space:]]*PasswordAuthentication[[:space:]]+/ {print $2}' \
        "$SSHD_CONFIG" 2>/dev/null | tail -1
    )
fi

# Ubuntu/Debian include files
if [[ -d /etc/ssh/sshd_config.d ]]; then

    tmp=$(awk '/^[[:space:]]*PermitRootLogin[[:space:]]+/ {print $2}' \
    /etc/ssh/sshd_config.d/*.conf 2>/dev/null | tail -1 || true)

    [[ -n "$tmp" ]] && root_login="$tmp"

    tmp=$(awk '/^[[:space:]]*PasswordAuthentication[[:space:]]+/ {print $2}' \
    /etc/ssh/sshd_config.d/*.conf 2>/dev/null | tail -1 || true)

    [[ -n "$tmp" ]] && password_auth="$tmp"
fi

root_login=${root_login:-Default}
password_auth=${password_auth:-Default}

printf "%-30s : %s\n" "PermitRootLogin" "$root_login"
printf "%-30s : %s\n" "PasswordAuthentication" "$password_auth"

if [[ "${root_login,,}" == "no" ]]; then
    ((score++))
fi

##############################################
# Failed SSH Logins
##############################################

failed_logins="0"

if command -v journalctl >/dev/null 2>&1; then

    failed_logins=$(
        journalctl --since "24 hours ago" 2>/dev/null \
        | grep -ic "Failed password" || true
    )
fi

printf "%-30s : %s\n" "Failed SSH Logins (24h)" "$failed_logins"

##############################################
# Firewall
##############################################

firewall="Not Installed"

if command -v ufw >/dev/null 2>&1; then

    firewall=$(ufw status 2>/dev/null | head -1 || echo "inactive")

    if [[ "$firewall" == *active* ]]; then
        ((score++))
    fi

elif command -v firewall-cmd >/dev/null 2>&1; then

    firewall=$(firewall-cmd --state 2>/dev/null || echo "inactive")

    if [[ "$firewall" == "running" ]]; then
        ((score++))
    fi
fi

printf "%-30s : %s\n" "Firewall" "$firewall"

##############################################
# SELinux / AppArmor
##############################################

framework="None"

if command -v getenforce >/dev/null 2>&1; then

    framework="SELinux ($(getenforce))"
    ((score++))

elif command -v aa-status >/dev/null 2>&1; then

    framework="AppArmor Enabled"
    ((score++))
fi

printf "%-30s : %s\n" "Security Framework" "$framework"

##############################################
# Listening Ports
##############################################

ports=$(
    ss -ltn 2>/dev/null \
    | awk 'NR>1{print $4}' \
    | awk -F: '{print $NF}' \
    | sort -nu \
    | paste -sd "," - || true
)

ports=${ports:-None}

printf "%-30s : %s\n" "Listening Ports" "$ports"

##############################################
# World Writable Files
##############################################

world_files=$(
    find /tmp /var/tmp \
    -type f \
    -perm -0002 \
    2>/dev/null \
    | wc -l
)

printf "%-30s : %s\n" "World Writable Files" "$world_files"

##############################################
# Score
##############################################

echo
echo "----------------------------------------------"

printf "%-30s : %d / %d\n" "Security Score" "$score" "$max_score"

echo

if (( score >= 4 )); then
    health="GOOD"
elif (( score >= 2 )); then
    health="WARNING"
else
    health="CRITICAL"
fi

echo "Overall Security : $health"

echo
