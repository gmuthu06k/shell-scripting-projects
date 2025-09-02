#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOG_FILE="$SCRIPT_DIR/software_install.log"
touch $LOG_FILE

DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Software installation started at $DATE" | tee -a "$LOG_FILE"

PACKAGE_FILE="$SCRIPT_DIR/packages.txt"

if [[ ! -f $PACKAGE_FILE ]]; then
	echo "Packages file not found: $PACKAGE_FILE" | tee -a "$LOG_FILE"
	exit 1
fi

mapfile -t PACKAGES < "$PACKAGE_FILE"

# Detect Package Manager
if command -v apt-get &>/dev/null; then
	PM="apt-get"
	INSTALL_CMD="sudo apt-get install -y"
	UPDATE_CMD="sudo apt-get update -y"
elif command -v yum &>/dev/null; then
	PM="yum"
	INSTALL_CMD="sudo yum install -y"
	UPDATE_CMD="sudo yum update -y"
elif command -v dnf &>/dev/null; then
	PM="dnf"
	INSTALL_CMD="sudo dnf install -y"
	UPDATE_CMD="sudo dnf update -y"
else
	echo "NO supported package manager found!" | tee -a "$LOG_FILE"
	exit 1
fi

# Update repositories
echo "Detected package manger: $PM" | tee -a "$LOG_FILE"
$UPDATE_CMD | tee -a $LOG_FILE

# Install Pacakges
for pkg in "${PACKAGES[@]}"; do
	[[ -z $pkg ]] && continue
	echo "Installing $pkg..." | tee -a "$LOG_FILE"
	if $INSTALL_CMD "$pkg" | tee -a "$LOG_FILE"; then
		echo "$pkg is successfully installed" | tee -a "$LOG_FILE"
	else
		echo "Failed to install $pkg" | tee -a "$LOG_FILE"
	fi
done

echo "Software installation completed at $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"


