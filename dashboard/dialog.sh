#!/usr/bin/env bash

###############################################################################
# InfraPulse Dialog Library
# Reusable dialog and message box functions
###############################################################################

set -euo pipefail

show_header() {
    local title="$1"

    printf "\n"
    printf "============================================================\n"
    printf " %s\n" "$title"
    printf "============================================================\n"
}

show_info() {
    local message="$1"
    printf "[INFO] %s\n" "$message"
}

show_success() {
    local message="$1"
    printf "[SUCCESS] %s\n" "$message"
}

show_warning() {
    local message="$1"
    printf "[WARNING] %s\n" "$message"
}

show_error() {
    local message="$1"
    printf "[ERROR] %s\n" "$message"
}

pause_screen() {
    read -r -p "Press Enter to continue..."
}

confirm_action() {
    local prompt="${1:-Are you sure?}"

    read -r -p "$prompt [y/N]: " reply

    case "$reply" in
        [Yy]|[Yy][Ee][Ss])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}
