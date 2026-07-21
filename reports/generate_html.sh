#!/usr/bin/env bash

###############################################################################
# InfraPulse HTML Report Generator
###############################################################################

set -euo pipefail

REPORT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REPORT_FILE="$REPORT_DIR/infrapulse_report.html"

HOSTNAME=$(hostname)

OS=$(grep "^PRETTY_NAME=" /etc/os-release | cut -d= -f2 | tr -d '"')

KERNEL=$(uname -r)

CPU=$(top -bn1 | awk '/Cpu\(s\)/ {printf "%.0f",100-$8}')

MEMORY=$(free | awk '/Mem:/ {printf "%.0f",($3/$2)*100}')

DISK=$(df / | awk 'NR==2 {print $5}')

if ping -c1 -W1 8.8.8.8 >/dev/null 2>&1
then
    NETWORK="Connected"
else
    NETWORK="Disconnected"
fi

DATE=$(date)

cat > "$REPORT_FILE" <<EOF
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>InfraPulse Report</title>

<style>

body{

font-family:Arial;

background:#f5f5f5;

margin:40px;

}

table{

border-collapse:collapse;

width:60%;

background:white;

}

th,td{

border:1px solid #ccc;

padding:10px;

}

th{

background:#0d6efd;

color:white;

}

h1{

color:#0d6efd;

}

</style>

</head>

<body>

<h1>InfraPulse Health Report</h1>

<p><strong>Generated:</strong> $DATE</p>

<table>

<tr><th>Metric</th><th>Value</th></tr>

<tr><td>Hostname</td><td>$HOSTNAME</td></tr>

<tr><td>Operating System</td><td>$OS</td></tr>

<tr><td>Kernel</td><td>$KERNEL</td></tr>

<tr><td>CPU Usage</td><td>$CPU%</td></tr>

<tr><td>Memory Usage</td><td>$MEMORY%</td></tr>

<tr><td>Disk Usage</td><td>$DISK</td></tr>

<tr><td>Network</td><td>$NETWORK</td></tr>

</table>

</body>

</html>
EOF

echo "HTML report generated successfully."

echo "Location: $REPORT_FILE"
