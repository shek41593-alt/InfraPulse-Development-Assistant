#!/usr/bin/env bash

###############################################################################
# InfraPulse Dashboard - System Panel
###############################################################################

show_system_panel() {

    local cpu_usage
    local mem_usage
    local disk_usage
    local network_status

    ##########################################################
    # CPU Usage
    ##########################################################

    cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {
        printf "%.0f", 100 - $8
    }')

    ##########################################################
    # Memory Usage
    ##########################################################

    mem_usage=$(free | awk '/Mem:/ {
        printf "%.0f", ($3/$2)*100
    }')

    ##########################################################
    # Disk Usage (/)
    ##########################################################

    disk_usage=$(df -h / | awk 'NR==2 {
        print $5
    }')

    ##########################################################
    # Network Status
    ##########################################################

    if ping -c1 -W1 8.8.8.8 >/dev/null 2>&1
    then
        network_status="Connected"
    else
        network_status="Disconnected"
    fi

    ##########################################################

    printf "=========================================================\n"
    printf "SYSTEM STATUS\n"
    printf "=========================================================\n"

    printf "%-22s : %s%%\n" "CPU Usage" "$cpu_usage"

    printf "%-22s : %s%%\n" "Memory Usage" "$mem_usage"

    printf "%-22s : %s\n" "Disk Usage (/)" "$disk_usage"

    printf "%-22s : %s\n" "Network" "$network_status"

    printf "\n"

}
