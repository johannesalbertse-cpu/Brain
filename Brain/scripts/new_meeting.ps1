param([string]\ = 'Brain Meeting')
\20260503-114827 = (Get-Date).ToString('yyyy-MM-dd_HHmm')
\ = Join-Path (Join-Path \C:\Users\johan 'Desktop\TerraFlux-Workspace\Brain\meetings') \"\20260503-114827 - \.md\"
\C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\templates\meeting-note.md = Join-Path (Join-Path \C:\Users\johan 'Desktop\TerraFlux-Workspace\Brain\templates') 'meeting-note.md'
if (Test-Path \C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\templates\meeting-note.md) { Copy-Item -Path \C:\Users\johan\Desktop\TerraFlux-Workspace\Brain\templates\meeting-note.md -Destination \ -Force }
else { New-Item -Path \ -ItemType File | Out-Null }
(Get-Content \) -replace '<Meeting Title>', \ | Set-Content \
Write-Host \"Created meeting note: \\"
