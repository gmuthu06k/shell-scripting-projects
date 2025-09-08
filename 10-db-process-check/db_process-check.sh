#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"&>/dev/null && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [[ -f "$ENV_FILE" ]]; then
	source "$ENV_FILE"
else
	echo ".env file not found, create $ENV_FILE with DB_USER, DB_PASS, DB_HOST." >&2
	exit 1
fi


LOG_FILE="$SCRIPT_DIR/db_process_check.log"
touch "$LOG_FILE"

log(){
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if ! mysqladmin -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" ping &>/dev/null; then
	log "ERROR: Cannot connect to MySQL at $DB_HOST"
	exit 1
fi

log "Connected to MySQL at $DB_HOST"

mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -e "SHOW FULL PROCESSLIST;" | tee -a "$LOG_FILE"

##########################################
#
# Detect Log Running queries
#
##########################################

log "Check for long-running queries (> 60s)..."
mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -e "SELECT Id, User, Host, Db, Command, Time, State, Info FROM information_schema.processlist WHERE command !='Sleep' AND Time >60;" | tee -a "$LOG_FILE"

log "Process check completed"
