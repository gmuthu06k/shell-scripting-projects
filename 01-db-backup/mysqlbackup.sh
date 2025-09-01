#!/bin/bash
set -euo pipefail

# Load credentials from .env (not checked into git)
# .env should define: DB_USER, DB_PASS, DB_NAME
ENV_FILE="$(dirname "$0")/.env"
if [[ -f "$ENV_FILE" ]]; then
# shellcheck disable=SC1090
source "$ENV_FILE"
else
	echo ".env file not found, create $ENV_FILE with DB_USER, DB_PASS, DB_NAME." >&2
	exit 1
fi

BACKUP_DIR="$(dirname "$0")/backups"
mkdir -p "$BACKUP_DIR"

DATE=$(date +%F_%H%M%S)
FILENAME="${BACKUP_DIR}/${DB_NAME}_${DATE}.sql"

# run mysqldump (no space after -p)
mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$FILENAME"

# compress to save space
gzip "$FILENAME"
echo "Backup saved: $FILENAME.gz"
