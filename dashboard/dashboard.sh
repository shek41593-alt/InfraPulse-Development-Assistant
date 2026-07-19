#!/usr/bin/env bash

###############################################################################
# InfraPulse Dashboard
###############################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DASHBOARD_DIR="$ROOT_DIR/dashboard"

required_files=(
    colors.sh
    header.sh
    system_panel.sh
    service_panel.sh
    security_panel.sh
    log_panel.sh
    footer.sh
)

for file in "${required_files[@]}"; do
    if [[ ! -f "$DASHBOARD_DIR/$file" ]]; then
        echo "[ERROR] Missing $file"
        exit 1
    fi
done

###############################################################################
# Load Components
###############################################################################

source "$DASHBOARD_DIR/colors.sh"
source "$DASHBOARD_DIR/header.sh"
source "$DASHBOARD_DIR/system_panel.sh"
source "$DASHBOARD_DIR/service_panel.sh"
source "$DASHBOARD_DIR/security_panel.sh"
source "$DASHBOARD_DIR/log_panel.sh"
source "$DASHBOARD_DIR/footer.sh"

###############################################################################
# Main
###############################################################################

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
