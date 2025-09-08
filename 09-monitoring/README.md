# System Monitor

A simple shell script that checks system health by monitoring CPU and memory usage. Alerts when usage exceeds configured thresholds and logs all activity with timestamps.

---

## Scripts

- **Script Name:** `system_monitor.sh`
- **Description:**  
  Monitors system performance by checking CPU usage and memory usage. Logs current metrics and generates alerts if thresholds are exceeded.

---

## Usage
1. **Configure thresholds (optional):**  
   Inside `system_monitor.sh`, adjust as needed:
   ```bash
   THRESHOLD_CPU=80     # CPU usage percentage threshold
   THRESHOLD_MEM=80     # Memory usage percentage threshold
   THRESHOLD_DISK=80     # Disk usage percentage threshold

2. Make the script executable:
   chmod +x system_monitor.sh

3. Run the script manually:
   ./system_monitor.sh

4. Check logs:
   system_monitor.log

5. Automate with cron (every 10 minutes):
   crontab -e
   
   Add the following line:
   */10 * * * * /bin/bash /path/to/system_monitor.sh

