param(
  [Parameter(Mandatory=$true)][string]$InputPath
)

if (-not (Test-Path $InputPath)) { Write-Host "Input file not found: $InputPath" -ForegroundColor Yellow; return $null }

$content = Get-Content $InputPath -Raw

# Redact email addresses
$content = [regex]::Replace($content, '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b', '[REDACTED_EMAIL]')

# Redact long digit sequences (possible keys, credit cards) of length 12+
$content = [regex]::Replace($content, '\b\d{12,}\b', '[REDACTED_DIGITS]')

# Redact simple API key patterns like sk-...
$content = [regex]::Replace($content, '\bsk-[A-Za-z0-9-_]{16,}\b', '[REDACTED_KEY]')

# Return redacted content
return $content
