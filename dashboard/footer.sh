#!/usr/bin/env bash

###############################################################################
# InfraPulse Dashboard - Footer
###############################################################################

show_footer() {

    local version="v1.0.0"
    local refresh_time
    local uptime
    local project_dir

    refresh_time=$(date "+%d-%b-%Y %H:%M:%S")

    uptime=$(uptime -p)

    project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

    printf "=========================================================\n"
    printf "DASHBOARD INFORMATION\n"
    printf "=========================================================\n"

    printf "%-20s : %s\n" "Version" "$version"
    printf "%-20s : %s\n" "Last Refresh" "$refresh_time"
    printf "%-20s : %s\n" "System Uptime" "$uptime"
    printf "%-20s : %s\n" "Project Path" "$project_dir"

    printf "\n"
    printf "=========================================================\n"
    printf "        InfraPulse Linux Monitoring Platform\n"
    printf "=========================================================\n"
}
