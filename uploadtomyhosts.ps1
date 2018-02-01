# <#
.SYNOPSIS
Upload a bunch of files or just one file to many hosts or just one host.
.DESCRIPTION
    Uses Putty PSCP utils to upload files to esxi hosts.
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any) $myhosts= IPs or FQDNs of hosts
.OUTPUTS
    
.NOTES
.Author: Frank Marroquin
www.FrankMarroquin.com @Frankrax
#>
#$myhosts = @("10.127.11.17","10.127.16.142","10.127.11.15","10.127.16.148","10.127.16.248","10.127.16.249")
$myhosts = @("10.127.11.13")
 
foreach ($myhost in $myhosts) 
{Start-process 'D:\utils\putty\PSCP.EXE' -ArgumentList ("-v -scp -pw password D:\CP032780\* root@$($myhost):/")}
#{Start-process 'D:\utils\putty\PSCP.EXE' -ArgumentList ("-v -scp -pw password D:\CP032780\* root@$($myhost):'/vmfs/volumes/datastore1 (5)/files'")}


<# Start-Sleep -s 20
foreach ($myhost in $myhosts) 
{Start-process 'D:\utils\putty\PSCP.EXE' -ArgumentList ("-v -scp -pw password D:\VMW-ESX-6.5.0-nhpsa-2.0.24-6797710\* root@$($myhost):/tmp/")} #>
 
