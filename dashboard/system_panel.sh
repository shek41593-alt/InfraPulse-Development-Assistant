#!/usr/bin/env bash

###############################################################################
# InfraPulse Dashboard - Enhanced System Panel
###############################################################################

progress_bar() {

    local value=$1
    local width=30

    local filled=$((value * width / 100))
    local empty=$((width - filled))

    printf "["

    for ((i=0; i<filled; i++)); do
        printf "#"
    done

    for ((i=0; i<empty; i++)); do
        printf "-"
    done

    printf "] %3d%%" "$value"
}

health_status() {

    local value=$1

    if (( value < 70 )); then
        status_color "HEALTHY"

    elif (( value < 90 )); then
        status_color "WARNING"

    else
        status_color "CRITICAL"
    fi
}

show_system_panel() {

    local cpu
    local mem
    local disk

    ############################################################
    # CPU
    ############################################################

    cpu=$(top -bn1 | awk '/Cpu\(s\)/ {printf "%.0f",100-$8}')

    ############################################################
    # Memory
    ############################################################

    mem=$(free | awk '/Mem:/ {printf "%.0f",($3/$2)*100}')

    ############################################################
    # Disk
    ############################################################

    disk=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

    section_title "SYSTEM STATUS"

    printf "%-12s " "CPU"
    progress_bar "$cpu"
    printf "   "
    health_status "$cpu"
    printf "\n"

    printf "%-12s " "Memory"
    progress_bar "$mem"
    printf "   "
    health_status "$mem"
    printf "\n"

    printf "%-12s " "Disk"
    progress_bar "$disk"
    printf "   "
    health_status "$disk"
    printf "\n"

    echo
}
