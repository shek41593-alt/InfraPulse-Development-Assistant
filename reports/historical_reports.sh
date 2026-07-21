#!/usr/bin/env bash

###############################################################################
# InfraPulse Historical Report Manager
###############################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

REPORT_DIR="$ROOT_DIR/reports"

ARCHIVE_DIR="$REPORT_DIR/archive"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$ARCHIVE_DIR/$TIMESTAMP"

echo "Creating historical report archive..."

for file in "$REPORT_DIR"/*.html "$REPORT_DIR"/*.json "$REPORT_DIR"/*.csv
do
    if [ -f "$file" ]; then
        cp "$file" "$ARCHIVE_DIR/$TIMESTAMP/"
        echo "Archived: $(basename "$file")"
    fi
done

echo
echo "Historical reports stored in:"
echo "$ARCHIVE_DIR/$TIMESTAMP"
