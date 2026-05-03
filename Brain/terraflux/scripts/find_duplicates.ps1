# find_duplicates.ps1 - writes duplicates_report.csv in terraflux/logs
\ = 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\logs\duplicates_report.csv'
\ = Get-ChildItem -Path 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain' -Recurse -File -Include *.md,*.pdf,*.docx,*.png,*.jpg -ErrorAction SilentlyContinue
\ = @()
foreach (\ in \) {
  try {
    \ = Get-FileHash -Path \.FullName -Algorithm SHA256
    \ += [PSCustomObject]@{ Path = \.FullName; Hash = \.Hash; Size = \.Length }
  } catch { }
}
\ = \ | Group-Object -Property Hash | Where-Object { \.Count -gt 1 }
\ = @()
foreach (\ in \) {
  foreach (\ in \.Group) {
    \ += [PSCustomObject]@{ Hash = \.Name; Path = \.Path; Size = [math]::Round(\.Size/1MB,2) }
  }
}
\ | Export-Csv -Path \ -NoTypeInformation -Force
Write-Host \"Duplicates report written to \\"
