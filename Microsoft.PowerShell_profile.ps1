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
<# you can add this to the function below to fancy it up more
$curtime = Get-Date

Write-Host -NoNewLine "p" -foregroundColor $foregroundColor
Write-Host -NoNewLine "$" -foregroundColor Green
Write-Host -NoNewLine "[" -foregroundColor Yellow
Write-Host -NoNewLine ("{0:HH}:{0:mm}:{0:ss}" -f (Get-Date)) -foregroundColor $foregroundColor
Write-Host -NoNewLine "]" -foregroundColor Yellow
Write-Host -NoNewLine ">" -foregroundColor Red
#this changes the title bar
$host.UI.RawUI.WindowTitle = "PS >> User: $curUser >> Current DIR: $((Get-Location).Path)"

Return " "
#>
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
