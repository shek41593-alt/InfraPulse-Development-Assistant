#!/bin/bash

# ==========================================================
# InfraPulse SSH Key Setup
# ==========================================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_FILE="$BASE_DIR/multiserver/servers.conf"

KEY_FILE="$HOME/.ssh/id_ed25519"

echo "=============================================="
echo "      InfraPulse SSH Key Configuration"
echo "=============================================="

# ----------------------------------------------------------
# Generate SSH key if missing
# ----------------------------------------------------------

if [[ ! -f "$KEY_FILE" ]]; then
    echo "No SSH key found."
    echo "Generating SSH key..."

    ssh-keygen -t ed25519 -N "" -f "$KEY_FILE"

    echo
    echo "SSH key generated."
else
    echo "SSH key already exists."
fi

echo

# ----------------------------------------------------------
# Copy key to all servers
# ----------------------------------------------------------

while IFS="|" read -r HOST IP USER
do
    [[ -z "$HOST" || "$HOST" =~ ^# ]] && continue

    echo "------------------------------------------"
    echo "Server : $HOST"
    echo "IP     : $IP"
    echo "User   : $USER"
    echo

    ssh-copy-id "${USER}@${IP}"

    echo
    echo "Testing SSH connection..."

    if ssh -n -T \
        -o BatchMode=yes \
        -o ConnectTimeout=5 \
        "${USER}@${IP}" "echo Connected" >/dev/null 2>&1
    then
        echo "SUCCESS : Passwordless SSH enabled."
    else
        echo "FAILED  : SSH key authentication failed."
    fi

    echo

done < "$SERVER_FILE"

echo "=============================================="
echo "SSH configuration completed."
echo "=============================================="
