#!/bin/bash
set -euo pipefail

SERVICE_NAME="apache2"
TIMESTAMP="$(date '+%Y-%m-%s %H:%M:%S')"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
LOG_FILE="$SCRIPT_DIR/script_monitor.log"

touch $LOG_FILE

if command -v systemctl; then
	if systemctl is-active --quiet $SERVICE_NAME; then
		echo "$SERVICE_NAME is running" | tee -a "$LOG_FILE"
	else
		echo "$SERVICE_NAME is DOWN" | tee -a "$LOG_FILE"
		echo "Trying to STRAT the $SERVICE_NAME" | tee -a "$LOG_FILE"
		systemctl start $SERVICE_NAME
		if systemctl is-active --quiet $SERVICE_NAME; then
			echo "$SERVICE_NAME is started successfully without any error" | tee -a "$LOG_FILE"
		else
			echo "$SERVICE_NAME is start is FAILED because of some error" | tee -a "$LOG_FILE"
			echo "Please check $LOG_FILE for more details about the error"
		fi
	fi
elif command -v service; then
	if service $SERVICE_NAME status; then
		echo "$SERVICE_NAME is running" | tee -a "$LOG_FILE"
	else
		echo "$SERVICE_NAME is DOWN" | tee -a "$LOG_FILE"
		echo "Trying to STRAT the $SERVICE_NAME" | tee -a "$LOG_FILE"
		service $SERVICE_NAME start
		if service $SERVICE_NAME status; then
			echo "$SERVICE_NAME is started successfully without any error" | tee -a "$LOG_FILE"
		else
			echo "$SERVICE_NAME is start is FAILED because of some error" | tee -a "$LOG_FILE"
			echo "Please check $LOG_FILE for more details about the error"
		fi
	fi
fi
