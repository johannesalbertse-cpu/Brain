param([string]\ = 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\vault\content', [string]\ = 'staging')

# This script is a scaffold. It reads markdown files, extracts YAML frontmatter, and posts metadata to a vector DB endpoint.
# DO NOT store API keys in this file. Use environment variables or a secret manager.

\ = Get-ChildItem -Path \ -Recurse -Filter *.md -File -ErrorAction SilentlyContinue
foreach (\ in \) {
  \ = Get-Content -Path \.FullName -Raw
  if (\ -match '^-{3}\s*(.*?)\s*-{3}\s*(.*)$'s) {
    \ = \[1]
    \ = \[2]
    try {
      # Parse YAML using Python helper to avoid adding a YAML parser in PowerShell
      \ = Join-Path 'C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\terraflux\tools\venv\Scripts' 'python.exe'
      \ = [System.IO.Path]::GetTempFileName()
      Set-Content -Path \ -Value \ -Encoding utf8
      \ = """ -c "import sys, yaml, json; print(json.dumps(yaml.safe_load(sys.stdin.read())))" < """
      \ = Invoke-Expression \
      # Placeholder: send metadata to vector DB endpoint (no keys logged)
      Write-Host "Would ingest: \.FullName (metadata keys: \)"
    } catch {
      Write-Host "YAML parse failed for \: \"
    }
  } else {
    Write-Host "No frontmatter in \"
  }
}
