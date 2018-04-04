# <#
.SYNOPSIS
Apply PerformanceOS to R740 for VMware specific profile to many hosts or just one host.
.DESCRIPTION
    Use REDFISH APis to apply and XML profile to hosts. 
.EXAMPLE
    Download scripts from https://github.com/dell/iDRAC-Redfish-Scripting
.INPUTS
    -idrac_ip 
    -idrac_username 
    -idrac_password 
    -XML fle
.OUTPUTS
    
.NOTES
.Author: Frank Marroquin
www.FrankMarroquin.com @Frankrax
#>

#$esxlist = @("10.127.88.115","10.10.10.12", "20.10.10.12")
$esxlist = @("10.10.77.205",
"10.10.72.107",
"10.10.77.210",
"10.10.77.218")
$root = "root" 
$Passwd = "calvincalvin"
#Check if module is loaded
If ( ! (Get-module Set-ImportServerConfigurationProfileLocalFilenameREDFISH )) {

    Import-Module -name "D:\iDRAC-Redfish-Scripting-master\iDRAC-Redfish-Scripting-master\Redfish PowerShell\Set-ImportServerConfigurationProfileLocalFilenameREDFISH\Set-ImportServerConfigurationProfileLocalFilenameREDFISH.psm1" -verbose
    
    }


$results = Foreach ($esx in $esxlist) {
Set-ImportServerConfigurationProfileLocalFilenameREDFISH -idrac_ip $esx -idrac_username $root -idrac_password $Passwd -Target ALL -FileName "D:\VMware_R740xd_2p_config.xml"
}
$results | Out-File d:\Redfish.txt -Append
