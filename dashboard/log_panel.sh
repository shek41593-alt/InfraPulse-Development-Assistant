#!/usr/bin/env bash

###############################################################################
# InfraPulse Dashboard - Log Panel
###############################################################################

show_log_panel() {

    local system_errors=0
    local apache_errors=0
    local tomcat_errors=0
    local mariadb_errors=0
    local docker_errors=0

    ############################################################
    # System Errors (last 24 hours)
    ############################################################

    if command -v journalctl >/dev/null 2>&1; then

        system_errors=$(
            journalctl --since "24 hours ago" -p err 2>/dev/null \
            | grep -vc "^--" || true
        )

    fi

    ############################################################
    # Apache Errors
    ############################################################

    if [[ -f /var/log/apache2/error.log ]]; then

        apache_errors=$(grep -ic "error" /var/log/apache2/error.log 2>/dev/null || true)

    elif [[ -f /var/log/httpd/error_log ]]; then

        apache_errors=$(grep -ic "error" /var/log/httpd/error_log 2>/dev/null || true)

    fi

    ############################################################
    # Tomcat Errors
    ############################################################

    for logfile in \
        /var/log/tomcat*/catalina*.log \
        /opt/tomcat/logs/catalina*.log
    do
        if [[ -f "$logfile" ]]; then
            tomcat_errors=$((tomcat_errors + $(grep -ic "error" "$logfile" 2>/dev/null || echo 0)))
        fi
    done

    ############################################################
    # MariaDB / MySQL Errors
    ############################################################

    for logfile in \
        /var/log/mysql/error.log \
        /var/log/mariadb/mariadb.log \
        /var/log/mysqld.log
    do
        if [[ -f "$logfile" ]]; then
            mariadb_errors=$((mariadb_errors + $(grep -ic "error" "$logfile" 2>/dev/null || echo 0)))
        fi
    done

    ############################################################
    # Docker Errors
    ############################################################

    if command -v docker >/dev/null 2>&1; then

        docker_errors=$(journalctl -u docker --since "24 hours ago" 2>/dev/null \
            | grep -ic "error" || true)

    fi

    ############################################################

    printf "=========================================================\n"
    printf "LOG SUMMARY (Last 24 Hours)\n"
    printf "=========================================================\n"

    printf "%-25s : %s\n" "System Errors" "$system_errors"
    printf "%-25s : %s\n" "Apache Errors" "$apache_errors"
    printf "%-25s : %s\n" "Tomcat Errors" "$tomcat_errors"
    printf "%-25s : %s\n" "MariaDB Errors" "$mariadb_errors"
    printf "%-25s : %s\n" "Docker Errors" "$docker_errors"

    printf "\n"
}
