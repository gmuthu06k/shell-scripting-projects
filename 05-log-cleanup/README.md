Script to clean log files older than 1 week to save disk space.

## 📌 Usage
1. Set `LOG_DIR` to your log folder and adjust `RETENTION_DAYS` if needed.
2. Make script executable:
   ```bash
   chmod +x log_cleanup.sh
3. Run manually:
./log_cleanup.sh
4. Deleted files are logged in log_cleanup.log (ignored in Git).
