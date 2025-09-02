#!/bin/bash
set -euo pipefail

LOG_DIR="/var/log/myapp"
RETENTION_DAYS=7
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOG_FILE="${SCRIPT_DIR}/log_clearnup_log"

touch "$LOG_FILE"

DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Clean up started at $DATE" | tee -a "$LOG_FILE"

find "$LOG_DIR" -type f -name "*.log" -mtime +$RETENTION_DAYS -print -exec rm -f {} \; | while read -r FILE; do
echo "Delete: $FILE" | tee -a "$LOG_FILE"
done

echo "Cleanup Completed at $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
echo "---------------------------------------------------------------" | tee -a "$LOG_FILE"
