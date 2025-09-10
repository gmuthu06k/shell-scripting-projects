# RAM Usage Alert Script

## Description
This script monitors free RAM on the Linux system.
If free memory drops below 20%, it logs an alert and sends an email notification.

## Usage
1. Update email in script:
   ```bash
   EMAIL="example@gmail.com"

2. Run Manually:
   ./send_email.sh

3. Check Logs:
   cat send_email.log

4. Automate via cron (every 5 min)
   */5 * * * * /home/USER/Muthu/shell-scripting-projects/09-ram-usage-alert/send_email.sh
