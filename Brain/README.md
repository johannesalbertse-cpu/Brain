# Brain — Quick Commands (TerraFlux)
Run these from any PowerShell prompt.

Daily start (Brain Mode):
  - Open PowerShell - Brain (shortcut) or run: brain

Quick commands:
  - Backup now: tf-backup
  - Healthcheck now: tf-health
  - Run ingest scaffold: tf-ingest
  - Find duplicates report: tf-finddups
  - Rotate logs: powershell -File terraflux\scripts\rotate_logs.ps1
  - Restore preview: powershell -File terraflux\scripts\restore_latest_backup.ps1

Maintenance:
  - Inspect status: terraflux\monitor\status.json
  - Inspect logs: terraflux\logs\

Security:
  - Do NOT store API keys in files. Use your secret manager or GitHub Actions secrets.
