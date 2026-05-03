param([switch]$List,[string]$ApproveId)
$Brain = Join-Path $env:USERPROFILE "Desktop\TerraFlux-Workspace\Brain"
$Queue = Join-Path $Brain "terraflux\nervous\queue"
$Archive = Join-Path $Brain "terraflux\nervous\archive"
$Audit = Join-Path $Brain "terraflux\nervous\audit"
$auditCsv = Join-Path $Audit "audit.csv"
function List-Pending {
  Get-ChildItem -Path $Queue -Filter "message-*.json" -File | ForEach-Object {
    $m = Get-Content $_.FullName -Raw | ConvertFrom-Json
    Write-Host "`nID: $($m.id)"
    Write-Host "Agent: $($m.agent)  Purpose: $($m.purpose)  Created: $($m.created_at)"
    Write-Host "Prompt (first 400 chars):"
    $m.payload.prompt.Substring(0,[math]::Min(400,$m.payload.prompt.Length)) | Write-Host
  }
}
if ($List) { List-Pending; exit 0 }
if (-not $ApproveId) { Write-Host "Usage: -List OR -ApproveId <id>"; exit 1 }
$msgFile = Join-Path $Queue ("message-$ApproveId.json")
if (-not (Test-Path $msgFile)) { Write-Host "Message not found: $msgFile"; exit 1 }
$m = Get-Content $msgFile -Raw | ConvertFrom-Json
Write-Host "You are approving message ID: $($m.id)"
Write-Host "Agent: $($m.agent)  Purpose: $($m.purpose)"
Write-Host "Full prompt:"
Write-Host $m.payload.prompt
$confirm = Read-Host "Type APPROVE to continue"
if ($confirm -ne "APPROVE") { Write-Host "Approval aborted"; exit 0 }
$payload = @{ id = $m.id; approved_by = $env:USERNAME; approved_at = (Get-Date).ToString("o"); payload = $m.payload }
$payloadPath = Join-Path $Queue ("payload-$($m.id).json")
$payload | ConvertTo-Json -Depth 10 | Out-File -FilePath $payloadPath -Encoding utf8 -Force
if (-not (Test-Path $Archive)) { New-Item -ItemType Directory -Path $Archive -Force | Out-Null }
Move-Item -Path $msgFile -Destination $Archive -Force
# update audit.csv (append approved line for simplicity)
"$($m.id),$($m.created_at),$($m.agent),$($m.purpose),$msgFile,approved,$env:USERNAME,$((Get-Date).ToString('o')),, " | Out-File -FilePath $auditCsv -Encoding utf8 -Append
Write-Host "Payload prepared: $payloadPath"
Write-Host "To send: use CI with secrets or run a secure client; do NOT store keys in repo."
