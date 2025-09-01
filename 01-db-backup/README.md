# 01-db-backup

Simple MySQL backup script that produces timestamped, gzipped SQL dumps.

## Usage

1. Copy `.env.example` to `.env` and fill in credentials.
2. Run manually:
   ```bash
   ./mysqlbackup.sh

3. To schedule weekly via cron (example runs every Sunday midnight):

0 0 * * 0 /bin/bash /home/you/projects/shell-scripting-projects/01-db-backup/mysqlbackup.sh >> /var/log/mysqlbackup.log 2>&1 
