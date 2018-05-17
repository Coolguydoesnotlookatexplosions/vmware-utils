# PowerCLI Script to Configure DNS and NTP on ESXi Hosts
# PowerCLI Session must be connected to vCenter Server using Connect-VIServer
 

# Prompt for Primary and Alternate DNS Servers

$dnspri = "10.65.208.4"
$dnsalt = "72.3.128.240"

<#
# Prompt for Domain
$domainname = read-host "Enter Domain Name"
#Prompt for NTP Servers
$ntpone = read-host "Enter NTP Server One"
$ntptwo = read-host "Enter NTP Server Two"
#>
 

$esxHosts = get-VMHost
foreach ($esx in $esxHosts) {
    Write-Host "Configuring DNS on $esx" -ForegroundColor Green
    Get-VMHostNetwork -VMHost $esx | Set-VMHostNetwork -DNSAddress $dnspri , $dnsalt -Confirm:$false
   #Write-Host "Configuring DNS and Domain Name on $esx" -ForegroundColor Green
   #Get-VMHostNetwork -VMHost $esx | Set-VMHostNetwork -DomainName $domainname -DNSAddress $dnspri , $dnsalt -Confirm:$false
<# 
   Write-Host "Configuring NTP Servers on $esx" -ForegroundColor Green
   Add-VMHostNTPServer -NtpServer $ntpone , $ntptwo -VMHost $esx -Confirm:$false

   Write-Host "Configuring NTP Client Policy on $esx" -ForegroundColor Green
   Get-VMHostService -VMHost $esx | where{$_.Key -eq "ntpd"} | Set-VMHostService -policy "on" -Confirm:$false



   Write-Host "Restarting NTP Client on $esx" -ForegroundColor Green

   Get-VMHostService -VMHost $esx | where{$_.Key -eq "ntpd"} | Restart-VMHostService -Confirm:$false
#>
}

Write-Host "Done!" -ForegroundColor Green
