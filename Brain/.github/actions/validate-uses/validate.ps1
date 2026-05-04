# validate.ps1
$patterns = @('powershell/powershell@v1','PowerShell/PowerShell@v1')
$bad = @()
Get-ChildItem -Path .github\workflows -Filter *.yml -Recurse -ErrorAction SilentlyContinue |
  ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern ($patterns -join '|') -List -ErrorAction SilentlyContinue
    if ($matches) { $bad += $matches }
  }
if ($bad.Count -gt 0) {
  $bad | ForEach-Object { Write-Host "Unsupported uses: $($_.Path):$($_.LineNumber) -> $($_.Line)" -ForegroundColor Red }
  exit 1
}
Write-Host "No unsupported uses: patterns found." -ForegroundColor Green
exit 0
