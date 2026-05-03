# rotate_logs.ps1 - move logs older than 30 days to backups/logs-archive
\ = 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\logs'
\ = 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\backups\logs-archive'
if (-not (Test-Path \)) { New-Item -ItemType Directory -Path \ | Out-Null }
Get-ChildItem -Path \ -File | Where-Object { \.LastWriteTime -lt (Get-Date).AddDays(-30) } | ForEach-Object {
  Move-Item -Path \.FullName -Destination (Join-Path \ \.Name) -Force
  Write-Host \"Archived log: \\"
}
