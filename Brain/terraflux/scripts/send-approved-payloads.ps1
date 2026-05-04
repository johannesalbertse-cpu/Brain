param(
  [string]$ApiKeyEnvVar = "COPILOT_API_KEY",
  [string]$Endpoint = "https://api.copilot.yourprovider/v1/respond",
  [int]$TimeoutSec = 120
)

$Root = Join-Path $env:USERPROFILE "Desktop\TerraFlux-Workspace\Brain"
$Queue = Join-Path $Root "terraflux\nervous\queue"
$Backups = Join-Path $Root "terraflux\backups"
$AuditCsv = Join-Path $Root "terraflux\nervous\audit\audit.csv"
$SendLog = Join-Path $Root "terraflux\nervous\send-log.csv"

if (-not (Test-Path $Queue)) { Write-Host "Queue folder not found: $Queue" -ForegroundColor Red; exit 1 }
if (-not (Test-Path $Backups)) { New-Item -ItemType Directory -Path $Backups -Force | Out-Null }

$apiKey = $env:$ApiKeyEnvVar
if (-not $apiKey) { Write-Host "Environment variable $ApiKeyEnvVar is not set. Set it and retry." -ForegroundColor Red; exit 1 }

$payloads = Get-ChildItem -Path $Queue -Filter "payload-*.json" -File -ErrorAction SilentlyContinue
if (-not $payloads) { Write-Host "No payload-*.json files found in queue." ; exit 0 }

foreach ($p in $payloads) {
  Write-Host "Sending $($p.Name)..."
  $body = Get-Content $p.FullName -Raw
  $responsePath = Join-Path $Backups ("$($p.BaseName)-response.json")
  try {
    $resp = Invoke-RestMethod -Uri $Endpoint -Method Post -Headers @{ Authorization = "Bearer $apiKey"; "Content-Type" = "application/json" } -Body $body -TimeoutSec $TimeoutSec
    $resp | ConvertTo-Json -Depth 12 | Out-File -FilePath $responsePath -Encoding utf8 -Force
    Write-Host "Saved response to $responsePath" -ForegroundColor Green

    # archive payload
    $archiveDir = Join-Path $Backups "payload-archive"
    if (-not (Test-Path $archiveDir)) { New-Item -ItemType Directory -Path $archiveDir -Force | Out-Null }
    Move-Item -Path $p.FullName -Destination $archiveDir -Force

    # audit and send log
    if (-not (Test-Path $AuditCsv)) { "id,created_at,agent,purpose,payload_path,status,approved_by,approved_at,result_path,notes" | Out-File -FilePath $AuditCsv -Encoding utf8 -Force }
    $payloadJson = $body | ConvertFrom-Json
    $id = $payloadJson.id
    "$id,$((Get-Date).ToString('o')),$($payloadJson.payload.model),$($payloadJson.payload.metadata.created_by),$p.FullName,sent,ci,$((Get-Date).ToString('o')),$responsePath,ci-send" | Out-File -FilePath $AuditCsv -Append -Encoding utf8
    "$((Get-Date).ToString('o')),$id,sent,$responsePath" | Out-File -FilePath $SendLog -Append -Encoding utf8
  } catch {
    Write-Host "Send failed for $($p.Name): $($_.Exception.Message)" -ForegroundColor Red
    "$((Get-Date).ToString('o')),$($p.Name),send_failed,$($_.Exception.Message)" | Out-File -FilePath $SendLog -Append -Encoding utf8
  }
}
