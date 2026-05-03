# restore_latest_backup.ps1 - dry-run by default; set -WhatIf to actually copy
\ = 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\backups'
if (-not (Test-Path \)) { Write-Host 'No backups found'; exit 0 }
\ = Get-ChildItem -Path \ -Filter *.zip | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not \) { Write-Host 'No backup zip found'; exit 0 }
Write-Host \"Latest backup: \\"
# Dry-run: list contents
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::OpenRead(\.FullName).Entries | Select FullName, Length | Out-File -FilePath 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\logs\restore_preview.txt' -Force
Write-Host \"Restore preview written to C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\logs\restore_preview.txt\"
Write-Host 'To restore, extract the zip manually or use Expand-Archive -Path <zip> -DestinationPath <dest>'
