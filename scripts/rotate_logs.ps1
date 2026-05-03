# Rotate logs older than 30 days into backups/logs-archive
\ = 'C:\Users\johan\Desktop\TerraFlux-Workspace\logs'
\ = 'C:\Users\johan\Desktop\TerraFlux-Workspace\backups\logs-archive'
if (-not (Test-Path \)) { New-Item -ItemType Directory -Path \ -Force | Out-Null }
Get-ChildItem -Path \ -File | Where-Object { \.LastWriteTime -lt (Get-Date).AddDays(-30) } | ForEach-Object {
  \ = Join-Path \ \.Name
  Move-Item -Path \.FullName -Destination \ -Force
  Write-Host \"Archived: \\"
}
