# validate_frontmatter.ps1
param([string]\ = 'vault\content')
if (Test-Path 'tools\validate_frontmatter.py') {
  python tools\validate_frontmatter.py --path \
} else {
  Write-Host 'validate_frontmatter.py not found in tools/ — please add it.'
}
