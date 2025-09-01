#!/bin/bash
set -euo pipefail

echo "Checking active services on $(hostname) at $(date)"
echo "--------------------------------------------------"

# If systemd is available
if command -V systemctl &>/dev/null; then
echo "Using systemctl (systemd detected)"
systemctl list-units --type=service --state=running
# If Service command is available (SysV init systems)
elif command -V service &>/dev/null; then
echo "Using service command (Sysv detected)"
service --status-all 2>/dev/null | grep "+"
# If neither found
else
echo "No supported init system found (Systemctl / service missing)"
fi
