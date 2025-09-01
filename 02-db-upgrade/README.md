# 02-db-upgrade

Automates MySQL database schema upgrades with backups and SQL migrations.

## 📌 Usage
1. Copy `.env.example` → `.env` and fill DB credentials.
2. Put your `.sql` migration files into the `migrations/` folder.
3. Run:
   ```bash
   ./upgrade.sh
