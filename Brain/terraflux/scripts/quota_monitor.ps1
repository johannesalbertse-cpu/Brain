# quota_monitor.ps1
\ = 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\logs\claude_requests.log'
\ = (Get-Content 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\tools\terraflux_config.json' -Raw | ConvertFrom-Json).daily_token_threshold
if (Test-Path \) {
  \ = (Get-Content \ | ForEach-Object { \ = \ -split ','; if (\.Length -ge 3) { [int]\[2] } else { 0 } } | Measure-Object -Sum).Sum
  if (\ -gt \) {
    Write-Host \"Quota exceeded: \ > \\" | Out-File -FilePath 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\logs\quota_alert.log' -Append
    # Placeholder: integrate with secret manager or API to disable key
  } else {
    Write-Host \"Quota OK: \ tokens\" | Out-File -FilePath 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\logs\quota_status.log' -Append
  }
} else {
  Write-Host 'No claude_requests.log found' | Out-File -FilePath 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\logs\quota_status.log' -Append
}
