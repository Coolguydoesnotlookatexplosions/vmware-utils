#path = c:\username\Documents\WindowsPowerShell
<# $productName = "PowerCLI"

function global:prompt {
    # Change default prompt
    Write-Host "$productName " -NoNewLine -foregroundcolor Green
    Write-Host ((Get-location).Path + ">") -NoNewLine
    return " "
}

Write-Host ("Loading PowerCLI modules..." + [Environment]::NewLine) -ForegroundColor Green #>

# Load modules
Get-Module -ListAvailable -Name VMware.PowerCLI
#Get-Module -ListAvailable -Name VMware.PowerCLI | Import-Module

# Change window title
#$powerCliFriendlyVersion = [VMware.VimAutomation.Sdk.Util10.ProductInfo]::PowerCLIFriendlyVersion
#$host.ui.RawUI.WindowTitle = $powerCliFriendlyVersion
$host.ui.RawUI.WindowTitle = "Now we are scripting"

#Set starting directory
cd \VDIProfiles$\FrankMarroquin\Documents\scripts
#set customer buffer size and window size
$Shell = $Host.UI.RawUI
$size = $Shell.WindowSize
$size.width=120
$size.height=75
$Shell.WindowSize = $size
$size = $Shell.BufferSize
$size.width=120
$size.height=5000
$Shell.BufferSize = $size

#custom prompt
Function Prompt 
{

    Write-Host ""

    IF ($global:DefaultVIServer) {
        Write-Host "[$($global:DefaultVIServer.name)]" -NoNewline -ForegroundColor green
    }

    Write-Host "$((Get-location).Path) $('-' * $Width)" -ForegroundColor red

    "MY Prompt:) "
   
}
#fix reloading profile every week
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore
