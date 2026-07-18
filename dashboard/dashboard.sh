#!/usr/bin/env bash

###############################################################################
# InfraPulse Dashboard
# Main Controller
###############################################################################

set -euo pipefail

# -----------------------------------------------------------------------------
# Project Directories
# -----------------------------------------------------------------------------

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DASHBOARD_DIR="$ROOT_DIR/dashboard"

# -----------------------------------------------------------------------------
# Verify Required Files
# -----------------------------------------------------------------------------

required_files=(
    header.sh
    system_panel.sh
    service_panel.sh
    security_panel.sh
    log_panel.sh
    footer.sh
)

for file in "${required_files[@]}"
do
    if [[ ! -f "$DASHBOARD_DIR/$file" ]]; then
        echo
        echo "[ERROR] Missing dashboard component:"
        echo "$file"
        echo
        exit 1
    fi
done

# -----------------------------------------------------------------------------
# Load Components
# -----------------------------------------------------------------------------

source "$DASHBOARD_DIR/header.sh"
source "$DASHBOARD_DIR/system_panel.sh"
source "$DASHBOARD_DIR/service_panel.sh"
source "$DASHBOARD_DIR/security_panel.sh"
source "$DASHBOARD_DIR/log_panel.sh"
source "$DASHBOARD_DIR/footer.sh"

# -----------------------------------------------------------------------------
# Dashboard
# -----------------------------------------------------------------------------

main() {

    clear

    show_header

    show_system_panel

    show_service_panel

    show_security_panel

    show_log_panel

    show_footer
}

main
