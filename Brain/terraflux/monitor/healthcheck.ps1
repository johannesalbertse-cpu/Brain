# terraflux\monitor\healthcheck.ps1
# Writes terraflux/monitor/status.json with basic health info (no secrets)

$status = [ordered]@{}
$status.timestamp = (Get-Date).ToString('o')

# Disk free on C:
$drive = Get-PSDrive -Name C -ErrorAction SilentlyContinue
if ($drive) {
  $status.disk_free_gb = [math]::Round($drive.Free / 1GB, 2)
} else {
  $status.disk_free_gb = $null
}

# Recent log errors (search for 'ERROR' in last 200 lines of logs)
$logDir = Join-Path (Split-Path $PSScriptRoot -Parent) "logs"
$errors = @()
if (Test-Path $logDir) {
  Get-ChildItem -Path $logDir -File | ForEach-Object {
    $tail = Get-Content -Path $_.FullName -Tail 200 -ErrorAction SilentlyContinue
    if ($tail -match 'ERROR') {
      $sample = ($tail | Select-String -Pattern 'ERROR' -SimpleMatch -AllMatches | Select-Object -First 1).Line
      $errors += [ordered]@{ file = $_.Name; sample = $sample }
    }
  }
}
$status.recent_log_errors = $errors

# Vector DB endpoint check (reads endpoint from config; does not log keys)
$configPath = Join-Path (Split-Path $PSScriptRoot -Parent) "tools\terraflux_config.json"
$status.vectordb = @{ reachable = $false; info = 'not checked' }
if (Test-Path $configPath) {
  try {
    $cfg = Get-Content -Path $configPath -Raw | ConvertFrom-Json
    if ($cfg.vectordb_endpoint -and $cfg.vectordb_endpoint -ne '') {
      try {
        $resp = Invoke-WebRequest -Uri $cfg.vectordb_endpoint -Method Head -TimeoutSec 8 -ErrorAction Stop
        $status.vectordb = @{ reachable = $true; status = $resp.StatusCode }
      } catch {
        $status.vectordb = @{ reachable = $false; error = $_.Exception.Message }
      }
    } else {
      $status.vectordb = @{ reachable = $false; error = 'no endpoint configured' }
    }
  } catch {
    $status.vectordb = @{ reachable = $false; error = 'config parse error' }
  }
}

# Write status.json
$out = Join-Path (Split-Path $PSScriptRoot -Parent) "monitor\status.json"
$monitorDir = Split-Path $out -Parent
if (-not (Test-Path $monitorDir)) { New-Item -ItemType Directory -Path $monitorDir -Force | Out-Null }
$status | ConvertTo-Json -Depth 6 | Out-File -FilePath $out -Encoding utf8 -Force

Write-Host "Healthcheck written to $out"
