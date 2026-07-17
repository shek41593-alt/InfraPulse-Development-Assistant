#!/usr/bin/env bash

LOG_FILE="logs/infrapulse.log"

log_info() {
    mkdir -p logs
    echo "[INFO] $(date '+%F %T') $1" >> "$LOG_FILE"
}

log_error() {
    mkdir -p logs
    echo "[ERROR] $(date '+%F %T') $1" >> "$LOG_FILE"
}
