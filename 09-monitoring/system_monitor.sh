#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"&>/dev/null && pwd)"
LOG_FILE="$SCRIPT_DIR/system_monitor.log"
THRESHOLD_CPU=80
THRESHOLD_MEM=80
THRESHOLD_DISK=80

touch $LOG_FILE

log(){
	echo "[$(date '+%Y-%m-%d %H:%M%:%S')] $1" | tee -a "$LOG_FILE"
}

log "============================ System Monitor Check ============================"

# CPU Usage
CPU_USAGE=$(LC_NUMERIC=C top -bn1 | grep "Cpu(s)" | awk '{printf("%.0f", 100 - $8)}')

if [[ $CPU_USAGE -gt $THRESHOLD_CPU ]]; then
	log "ALERT: High CPU usage - $CPU_USAGE% (Threshold: $THRESHOLD_CPU%)"
else
	log "CPU usage is normal: $CPU_USAGE%"
fi

# Memory Usage
MEM_USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100.0}')
if [[ $MEM_USAGE -gt $THRESHOLD_MEM ]]; then
	log "ALERT: High Memory usage - $MEM_USAGE% (Threshold: $THRESHOLD_MEM%)"
else
	log "Memory usage is normal: $MEM_USAGE%"
fi

# Disk Usage
df -h --exclude-type=tmpfs --exclude-type=overlay | awk 'NR>1 {print $1, $5, $6}' | while read -r FS USAGE MNT; do
	PCT=$(echo $USAGE | tr -d '%')
	if [[ $PCT -gt $THRESHOLD_DISK ]]; then
		log "ALERT: Disk $FS mounted on $MNT at $PCT% usage (Threshold: $THRESHOLD_DISK%)"
	else
		log "Disk $FS mounted on $MNT usage is normal: $PCT%"
	fi
done

#UPTIME & LOAD
UPTIME=$(uptime -p)
LOAD=$(uptime | awk -F'load average:' '{print $2}' | xargs)
log "Uptime: $UPTIME"
log "Load Averages: $LOAD"

log "============================ Monitor Check Completed ============================"
echo " " >> $LOG_FILE

