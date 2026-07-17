#!/usr/bin/env bash

source "$(dirname "$0")/colors.sh"

while true; do
    clear
    info "========== InfraPulse =========="
    echo "1) System Monitoring"
    echo "2) Service Monitoring"
    echo "3) Security Audit"
    echo "4) Log Analysis"
    echo "5) Exit"
    echo

    read -rp "Select an option: " choice

    case "$choice" in
        1) success "System Monitoring module (coming soon)";;
        2) success "Service Monitoring module (coming soon)";;
        3) success "Security Audit module (coming soon)";;
        4) success "Log Analysis module (coming soon)";;
        5) exit 0;;
        *) error "Invalid option";;
    esac

    read -rp "Press Enter to continue..."
done
