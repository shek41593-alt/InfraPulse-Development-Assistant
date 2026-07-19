#!/usr/bin/env bash

###############################################################################
# InfraPulse Dashboard - Security Panel
###############################################################################

show_security_panel() {

    local sshd_config="/etc/ssh/sshd_config"

    local root_login="Default"
    local password_auth="Default"
    local firewall="Not Installed"
    local framework="None"
    local failed_logins="0"

    ############################################################
    # SSH Configuration
    ############################################################

    if [[ -f "$sshd_config" ]]; then

        root_login=$(
            awk '/^[[:space:]]*PermitRootLogin/ {print $2}' \
            "$sshd_config" | tail -1
        )

        password_auth=$(
            awk '/^[[:space:]]*PasswordAuthentication/ {print $2}' \
            "$sshd_config" | tail -1
        )
    fi

    ############################################################
    # Ubuntu include directory
    ############################################################

    if [[ -d /etc/ssh/sshd_config.d ]]; then

        tmp=$(
            awk '/^[[:space:]]*PermitRootLogin/ {print $2}' \
            /etc/ssh/sshd_config.d/*.conf 2>/dev/null \
            | tail -1 || true
        )

        [[ -n "$tmp" ]] && root_login="$tmp"

        tmp=$(
            awk '/^[[:space:]]*PasswordAuthentication/ {print $2}' \
            /etc/ssh/sshd_config.d/*.conf 2>/dev/null \
            | tail -1 || true
        )

        [[ -n "$tmp" ]] && password_auth="$tmp"
    fi

    root_login=${root_login:-Default}
    password_auth=${password_auth:-Default}

    ############################################################
    # Firewall
    ############################################################

    if command -v ufw >/dev/null 2>&1; then

        firewall=$(ufw status | head -1)

    elif command -v firewall-cmd >/dev/null 2>&1; then

        firewall=$(firewall-cmd --state 2>/dev/null || echo "inactive")

    fi

    ############################################################
    # Security Framework
    ############################################################

    if command -v getenforce >/dev/null 2>&1; then

        framework="SELinux ($(getenforce))"

    elif command -v aa-status >/dev/null 2>&1; then

        framework="AppArmor"

    fi

    ############################################################
    # Failed SSH Logins
    ############################################################

    if command -v journalctl >/dev/null 2>&1; then

        failed_logins=$(
            journalctl --since "24 hours ago" 2>/dev/null \
            | grep -ic "Failed password" || true
        )

    fi

    ############################################################

    printf "=========================================================\n"
    printf "SECURITY\n"
    printf "=========================================================\n"

    printf "%-24s : %s\n" "PermitRootLogin" "$root_login"

    printf "%-24s : %s\n" "PasswordAuthentication" "$password_auth"

    printf "%-24s : %s\n" "Firewall" "$firewall"

    printf "%-24s : %s\n" "Security Framework" "$framework"

    printf "%-24s : %s\n" "Failed SSH Logins" "$failed_logins"

    printf "\n"
}
