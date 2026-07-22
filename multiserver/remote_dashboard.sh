#!/bin/bash

# ==========================================================
# InfraPulse Remote Dashboard
# ==========================================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_FILE="$BASE_DIR/multiserver/servers.conf"

clear

echo "=========================================================================="
echo "                    InfraPulse Remote Dashboard"
echo "=========================================================================="
printf "%-15s %-15s %-8s %-8s %-10s %-20s\n" \
"HOST" "CPU" "MEM" "DISK" "STATUS" "UPTIME"
echo "--------------------------------------------------------------------------"

if [[ ! -f "$SERVER_FILE" ]]; then
    echo "Server inventory not found!"
    exit 1
fi

while IFS="|" read -r HOST IP USER
do
    # Skip blank lines/comments
    [[ -z "$HOST" || "$HOST" =~ ^# ]] && continue

    SSH_OUTPUT=$(ssh \
        -T \
        -o BatchMode=yes \
        -o ConnectTimeout=5 \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        "${USER}@${IP}" <<'EOF'
CPU=$(top -bn1 | awk -F',' '/Cpu\(s\)/ {gsub("%",""); print int($1)}')

MEM=$(free | awk '/Mem:/ {
printf("%.0f",$3/$2*100)
}')

DISK=$(df / | awk 'NR==2{
gsub("%","")
print $5
}')

UPTIME=$(uptime -p)

echo "${CPU}|${MEM}|${DISK}|${UPTIME}"
EOF
)

    if [[ $? -ne 0 || -z "$SSH_OUTPUT" ]]; then
        printf "%-15s %-15s %-8s %-8s %-10s %-20s\n" \
        "$HOST" "-" "-" "-" "OFFLINE" "-"
        continue
    fi

    IFS="|" read -r CPU MEM DISK UPTIME <<< "$SSH_OUTPUT"

    CPU=${CPU:-0}
    MEM=${MEM:-0}
    DISK=${DISK:-0}

    printf "%-15s %-15s %-8s %-8s %-10s %-20s\n" \
    "$HOST" \
    "${CPU}%" \
    "${MEM}%" \
    "${DISK}%" \
    "ONLINE" \
    "$UPTIME"

done < "$SERVER_FILE"

echo
echo "Dashboard refreshed at $(date)"
