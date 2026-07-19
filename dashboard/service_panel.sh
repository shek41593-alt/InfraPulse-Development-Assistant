#!/usr/bin/env bash

###############################################################################
# InfraPulse Dashboard - Service Panel
###############################################################################

check_service() {

    local service="$1"

    if ! systemctl list-unit-files 2>/dev/null | grep -q "^${service}\.service"; then

        printf "%-15s %-15s %-12s %-10s\n" \
        "$service" "Not Installed" "-" "-"

        return
    fi

    local status
    local enabled
    local pid

    status=$(systemctl is-active "$service" 2>/dev/null || echo "inactive")

    enabled=$(systemctl is-enabled "$service" 2>/dev/null || echo "disabled")

    pid=$(systemctl show -p MainPID "$service" | cut -d= -f2)

    [[ "$pid" == "0" ]] && pid="-"

    printf "%-15s %-15s %-12s %-10s\n" \
    "$service" "$status" "$enabled" "$pid"
}

show_service_panel() {

    printf "=========================================================\n"
    printf "SERVICES\n"
    printf "=========================================================\n"

    printf "%-15s %-15s %-12s %-10s\n" \
    "Service" "Status" "Enabled" "PID"

    printf "%-15s %-15s %-12s %-10s\n" \
    "---------------" \
    "---------------" \
    "------------" \
    "----------"

    #############################################################

    if systemctl list-unit-files | grep -q "^apache2.service"; then
        check_service apache2
    else
        check_service httpd
    fi

    #############################################################

    if systemctl list-unit-files | grep -q "^tomcat10.service"; then
        check_service tomcat10
    elif systemctl list-unit-files | grep -q "^tomcat9.service"; then
        check_service tomcat9
    else
        check_service tomcat
    fi

    #############################################################

    if systemctl list-unit-files | grep -q "^mariadb.service"; then
        check_service mariadb
    elif systemctl list-unit-files | grep -q "^mysql.service"; then
        check_service mysql
    else
        check_service mysqld
    fi

    #############################################################

    check_service docker

    printf "\n"

}
