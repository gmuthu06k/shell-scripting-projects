#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
HOST_FILE="$SCRIPT_DIR/hosts.txt"                      # one host/IP per line
LOG_FILE="$SCRIPT_DIR/connectivity_check.log"
UNREACHABLE_FILE="$SCRIPT_DIR/unreachable.txt"
CONCURRENCY=100
TIMEOUT=2

ALERT_EMAIL="admin@xyz.com"
ALERT_SUBJECT="CONNECTIVITY ALERT: Some Hosts unreachable"

touch "$LOG_FILE"

: > "$UNREACHABLE_FILE"

if [[ ! -s $HOST_FILE ]]; then
	echo "hosts.txt file is missing or empty" | tee -a "$LOG_FILE"
	exit 1
fi

start_time="$(date '+%Y-%m-%d %H:%M:%S')"
echo "Connectivity check started at $start_time" | tee -a "$LOG_FILE"


################################
#
# Function to Check Host
#
################################

check_host() {
	local host="$1"
	if ping -c1 -W"$TIMEOUT" "$host" &>/dev/null;then
		echo "$host reachable" | tee -a "$LOG_FILE"
	else
		echo "$host unreachable" | tee -a "$LOG_FILE"
		echo "$host" >> "$UNREACHABLE_FILE"
	fi
}

export -f check_host
export LOG_FILE UNREACHABLE_FILE TIMEOUT


####################################
#
# Run in parallel
#
###################################
if command -v parallel; then
	parallel -j "$CONCURRENCY" check_host :::: "$HOSTS_FILE"
else
	xargs -I{} -P "$CONCURRENCY" bash -c 'check_host "$@"' _ {} < "$HOST_FILE"
fi

###################################
#
# Summary & Alerts
#
###################################
end_time="$(date '+%Y-%m-%d %H:%M:%S')"
unreachable_count=$(wc -l < "$UNREACHABLE_FILE" | xargs || echo 0)
echo "Completed at $end_time. Unreachable: $unreachable_count" | tee -a "$LOG_FILE"

if [ "$unreachable_count" -gt 0 ]; then
	echo "ALERT: $unreachable_count hots(s) unreachable. See $UNREACHABLE_FILE" | tee -a "$LOG_FILE"

	if [[ -n $ALERT_EMAIL ]]; then
		{
			echo "Connectivity check at $end_time"
			echo "Unreachable count: $unreachable_count"
			echo "List of unreachable hosts:"
			cat "$UNREACHABLE_FILE"
		} | mail -s "$ALERT_SUBJECT" "$ALERT_EMAIL"
	fi
fi

