#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
LOG_FILE="$SCRIPT_DIR/send_email.log"
touch "$LOG_FILE"

THRESHOLD=20   # percent free memory
EMAIL="example@gmail.com"
EMAIL_SUB="ALERT: High RAM usage on $(hostname)"

log(){
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

FREE_MEM=$(free | awk '/Mem:/ {printf("%.0f", $7/$2 * 100)}')

if [[ $FREE_MEM -lt $THRESHOLD ]]; then
    log "ALERT: Free memory is below ${THRESHOLD}% (currently ${FREE_MEM}%)."
    mail -s "$EMAIL_SUB" "$EMAIL" < "$LOG_FILE"
else
    log "Memory usage is under control. Free: ${FREE_MEM}%"
fi
