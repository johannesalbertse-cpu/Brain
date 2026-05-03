# open_brain.ps1 - opens a new PowerShell window in Brain
param([string]\ = 'Brain')
Start-Process -FilePath "C:\Program Files\WindowsApps\Microsoft.PowerShell_7.6.1.0_x64__8wekyb3d8bbwe\pwsh.exe" -ArgumentList '-NoExit','-Command',"Set-Location "C:\Users\johan\Desktop\TerraFlux-Workspace\Brain";$Host.UI.RawUI.WindowTitle = 'PowerShell - Brain'" -WorkingDirectory "C:\Users\johan\Desktop\TerraFlux-Workspace\Brain"
