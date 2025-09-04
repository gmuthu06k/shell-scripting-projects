Description:
This script automatically checks if a given Linux service (default: apache2) is running.
If the service is down, it attempts to restart it and logs the result

Usage:
1. Update the script with your service name (default: apache2):
	SERVICE_NAME="apache2"
2. Run the script manually:
	sudo ./start_service.sh
3. Check logs in:
	service_monitor.log
4. Automate with cron to check every 5 minutes:
	crontab -e

   Add the following line:
	*/5 * * * * /bin/bash /path/to/start_service.sh

Features:
* Works with both systemctl and legacy service.
* Auto-restarts down services.
* Logs all actions with timestamps.

