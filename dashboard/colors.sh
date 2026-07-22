#!/usr/bin/env bash

# shellcheck disable=SC2034

###############################################################################
# InfraPulse Dashboard Color Library
###############################################################################

set -euo pipefail

# Reset
RESET="\033[0m"

# Standard Colors
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"

# Bold Colors
BOLD="\033[1m"
BOLD_RED="\033[1;31m"
BOLD_GREEN="\033[1;32m"
BOLD_YELLOW="\033[1;33m"
BOLD_BLUE="\033[1;34m"
BOLD_PURPLE="\033[1;35m"
BOLD_CYAN="\033[1;36m"

# Bright Colors
BRIGHT_RED="\033[91m"
BRIGHT_GREEN="\033[92m"
BRIGHT_YELLOW="\033[93m"
BRIGHT_BLUE="\033[94m"
BRIGHT_PURPLE="\033[95m"
BRIGHT_CYAN="\033[96m"

# Extra Formatting
DIM="\033[2m"
UNDERLINE="\033[4m"
BLINK="\033[5m"

print_title() {
    printf "%b" "${BOLD}${BRIGHT_CYAN}"
    printf "============================================================\n"
    printf "                    InfraPulse Dashboard\n"
    printf "============================================================\n"
    printf "%b" "${RESET}"
}

print_success() {
    printf "%b%s%b\n" "$GREEN" "$1" "$RESET"
}

print_warning() {
    printf "%b%s%b\n" "$YELLOW" "$1" "$RESET"
}

print_error() {
    printf "%b%s%b\n" "$RED" "$1" "$RESET"
}

print_info() {
    printf "%b%s%b\n" "$CYAN" "$1" "$RESET"
}
