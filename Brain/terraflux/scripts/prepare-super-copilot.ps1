param(
  [string]$AgentId = "super-copilot",
  [string]$Purpose = "unspecified",
  [string]$Prompt = "",
  [string[]]$Files = @(),
  [int]$TopK = 5
)

$Brain = Join-Path $env:USERPROFILE "Desktop\TerraFlux-Workspace\Brain"
$Queue = Join-Path $Brain "terraflux\nervous\queue"
$Audit = Join-Path $Brain "terraflux\nervous\audit"
if (-not (Test-Path $Queue)) { New-Item -ItemType Directory -Path $Queue -Force | Out-Null }
if (-not (Test-Path $Audit)) { New-Item -ItemType Directory -Path $Audit -Force | Out-Null }

$id = [guid]::NewGuid().ToString()
$msg = [ordered]@{
  id = $id
  created_at = (Get-Date).ToString("o")
  agent = $AgentId
  purpose = $Purpose
  files = $Files
  retrieval = @{ enabled = $true; top_k = $TopK }
  payload = @{ model = "copilot-latest"; prompt = $Prompt; metadata = @{ created_by = $env:USERNAME } }
  status = "pending"
  approval = @{ required = $true; approved_by = $null; approved_at = $null }
}
$msgPath = Join-Path $Queue ("message-$id.json")
$msg | ConvertTo-Json -Depth 12 | Out-File -FilePath $msgPath -Encoding utf8 -Force

$auditCsv = Join-Path $Audit "audit.csv"
if (-not (Test-Path $auditCsv)) { "id,created_at,agent,purpose,payload_path,status,approved_by,approved_at,result_path,notes" | Out-File $auditCsv -Encoding utf8 -Force }
"$id,$($msg.created_at),$AgentId,$Purpose,$msgPath,pending,," | Out-File -FilePath $auditCsv -Encoding utf8 -Append

Write-Host "Prepared message: $msgPath"
