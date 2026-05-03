# scheduled_backup.ps1
\ = 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\backups'
if (-not (Test-Path \)) { New-Item -ItemType Directory -Path \ | Out-Null }
\ = (Get-Date).ToString('yyyyMMdd-HHmmss')
\ = Join-Path \ \"brain-backup-\.zip\"
Compress-Archive -Path 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\*' -DestinationPath \ -Force
Write-Host \"Created backup: \\"
