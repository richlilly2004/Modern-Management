# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}
$AssignedUser = Read-Host -Prompt 'Please type your Netrix e-mail address (ie jdoe@netrixllc.com)'
$TenantId = “XXXXXXXXXXXXXXXXXX”
$AppId = “XXXXXXXXXXXXXXXXXX”
$AppSecret = "XXXXXXXXXXXXXXXXXX"
Write-Host -ForegroundColor Red "Loading variables"

Write-Host -ForegroundColor Red "Installing scripts/modules"
Set-ExecutionPolicy -ExecutionPolicy Bypass
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Script Get-WindowsAutopilotInfo

Write-Host -ForegroundColor Red "Getting & Uploading Hash"
.\Get-WindowsAutoPilotInfo.ps1 -AssignedUser $AssignedUser -TenantId $TenantId -AppId $AppId -AppSecret $AppSecret -Online -Assign

Write-Host -ForegroundColor Red "You can now go to Settings > Update & Security > Recovery > Reset this PC (Please choose remove everything)"