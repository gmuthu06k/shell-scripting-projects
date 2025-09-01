#!/bin/bash
set -euo pipefail

export PATH="/usr/local/bin:/usr/bin:/bin"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"
MIGRATION_DIR="$SCRIPT_DIR/migrations"
BACKUP_DIR="$SCRIPT_DIR/backups"
LOG_FILE="$SCRIPT_DIR/upgrade.log"

if [[ ! -f "$ENV_FILE" ]]; then
	echo "Missing $ENV_FILE. Copy .env.example to .env and fill details." | tee -a "$LOG_FILE"
	exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

mkdir -p "$BACKUP_DIR"

DATE=$(date +%F_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_before_upgrade_${DATE}.sql.gz"

# step 1: backup
echo "Taking Backup: $BACKUP_FILE" | tee -a "$LOG_FILE"
mysqldump -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" | gzip > "$BACKUP_FILE"

# step2: Apply Migration
for file in "$MIGRATION_DIR"/*.sql; do
	[ -e "$file" ] || { echo "No migrations found."; break; }
	echo "Running: $file" | tee -a "$LOG_FILE"
	mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$file" \
		&& echo "SUCCESS: $file" | tee -a "$LOG_FILE" \
		|| { echo "FAILED: $file" | tee -a "$LOG_FILE"; exit 1; }
	done

	echo "Upgrade completed at $(date -Is)" | tee -a "$LOG_FILE"

