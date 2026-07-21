#!/usr/bin/env bash

###############################################################################
# InfraPulse Archive Cleanup Utility
###############################################################################

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ARCHIVE_DIR="$ROOT_DIR/reports/archive"

RETENTION_DAYS="${1:-30}"

if [ ! -d "$ARCHIVE_DIR" ]; then
    echo "Archive directory not found."
    exit 0
fi

echo "========================================="
echo "      InfraPulse Archive Cleanup"
echo "========================================="
echo
echo "Retention Period : $RETENTION_DAYS days"
echo

DELETED=0

while IFS= read -r dir
do
    echo "Removing: $dir"
    rm -rf "$dir"
    ((DELETED++))
done < <(find "$ARCHIVE_DIR" -mindepth 1 -maxdepth 1 -type d -mtime +"$RETENTION_DAYS")

echo
echo "Cleanup Complete"
echo "Archives Removed : $DELETED"
echo "Retention Policy : $RETENTION_DAYS days"
