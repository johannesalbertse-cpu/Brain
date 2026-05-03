# Simple snapshot: creates a zip of the workspace backups folder
param([string]\ = 'C:\Users\johan\Desktop\TerraFlux-Workspace\backups')
if (-not (Test-Path \)) { New-Item -ItemType Directory -Path \ -Force | Out-Null }
\20260503-113827 = (Get-Date).ToString('yyyyMMdd-HHmmss')
\ = Join-Path \ \"terraflux-\20260503-113827.zip\"
Compress-Archive -Path 'C:\Users\johan\Desktop\TerraFlux-Workspace\*' -DestinationPath \ -Force
Write-Host \"Snapshot created: \\"
