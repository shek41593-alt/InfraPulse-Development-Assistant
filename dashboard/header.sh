#!/usr/bin/env bash

###############################################################################
# InfraPulse Dashboard Header
###############################################################################

show_header() {

    local hostname
    local username
    local os
    local kernel
    local uptime
    local datetime

    hostname=$(hostname)

    username=$(whoami)

    os=$(grep "^PRETTY_NAME=" /etc/os-release | cut -d= -f2 | tr -d '"')

    kernel=$(uname -r)

    uptime=$(uptime -p)

    datetime=$(date "+%d-%b-%Y %I:%M:%S %p")

    printf "\n"

    printf "=========================================================================\n"
    printf "                           INFRAPULSE DASHBOARD\n"
    printf "=========================================================================\n"

    printf "%-18s : %s\n" "Hostname" "$hostname"
    printf "%-18s : %s\n" "User" "$username"
    printf "%-18s : %s\n" "Operating System" "$os"
    printf "%-18s : %s\n" "Kernel" "$kernel"
    printf "%-18s : %s\n" "System Uptime" "$uptime"
    printf "%-18s : %s\n" "Generated At" "$datetime"

    printf "\n"
}
