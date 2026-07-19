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
    kernel=$(uname -r)
    uptime=$(uptime -p)
    datetime=$(date "+%d-%b-%Y %H:%M:%S")

    if [[ -f /etc/os-release ]]; then
        os=$(grep "^PRETTY_NAME=" /etc/os-release | cut -d= -f2 | tr -d '"')
    else
        os="Unknown"
    fi

    clear

    printf "${BRIGHT_CYAN}${BOLD}"
    cat <<'EOF'
   ___        __            ____        __
  / _ \____  / /________ _ / __ \__  __/ /_______
 / ___/ __ \/ __/ ___/  ' / /_/ / / / / / ___/ _ \
/ /  / / / / /_/ /  / /| / ____/ /_/ / (__  )  __/
/_/  /_/ /_/\__/_/  /_/ |_/_/    \__,_/_/____/\___/

EOF
    printf "${RESET}"

    printf "${BOLD}InfraPulse Linux Infrastructure Monitoring Platform${RESET}\n\n"

    section_title "SYSTEM INFORMATION"

    print_row "Hostname" "${BRIGHT_GREEN}${hostname}${RESET}"
    print_row "User" "${BRIGHT_GREEN}${username}${RESET}"
    print_row "Operating System" "$os"
    print_row "Kernel" "$kernel"
    print_row "System Uptime" "$uptime"
    print_row "Generated At" "$datetime"

    echo
}
