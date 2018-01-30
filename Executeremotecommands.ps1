
# Author: Frank Marroquin
# Website: www.FrankMarroquin.com
# Description: This script will run commands on an esxi 6.5 hyp. A few examples are included. It leverages putty plink to do the main lifting.
# This script will also run esxicli commands and hpssa commands.
#Use these at your own risk. 
# Reference:  #ADAPATED FROM https://communities.vmware.com/thread/558507
# Credit: 
# Changelog


$root = "root" 
$Passwd = "password"
#all hosts
#$esxlist = @("10.127.116.137","10.127.116.140","10.127.116.145","10.127.116.148","10.127.116.248","10.127.116.249")
#just one host
#$esxlist = @("10.127.116.137")
#ok now do the rest
$esxlist = @("10.127.116.140","10.127.116.145","10.127.116.148","10.127.116.248","10.127.116.249")

#This is where you edit the commands you want to run. This script has two examples
<# $cmd = @'
"cp /var/spool/cron/crontabs/root /var/spool/cron/crontabs/root.bak "
'@
$cmd1= @'
"sed -e '/device\ purge/s/^/#/g' -i /var/spool/cron/crontabs/root"
'@ #>
################################################
<# $cmd = @'
"ls /tmp "
'@
$cmd1= @'
"cat /etc/hosts"
'@ #>
###################
#this part hows me the cards.
<# $cmd = @'
esxcli ssacli cmd --cmdopts="controller All show config"
'@ #>
###################
$cmd = @'
"chmod +x /tmp/CP032780.vmexe"
'@
#maybe add in a ch to /tmp first
$cmd1 = @'
'/tmp/CP032780.vmexe --rewrite --force --silent --log-dir=/tmp'
'@
$cmd2= @'
"esxcli software vib update -d /tmp/VMW-ESX-6.5.0-nhpsa-2.0.24-offline_bundle-6797710.zip"
'@

##Putty commands
$plink = "D:\utils\putty\plink.exe" #Provide the path of plink
$PlinkOptions = " -v -batch -pw $Passwd"
$remoteCommand = '"' + $cmd + '"'
$remoteCommand1 = '"' + $cmd1 + '"'
$remoteCommand2 = '"' + $cmd2 + '"'

foreach ($esx in $esxlist) {
Connect-VIServer $esx -User  $root -Password $Passwd
Write-Host -Object "starting ssh services on $esx"
$sshstatus= Get-VMHostService  -VMHost $esx| where {$psitem.key -eq "tsm-ssh"}
if ($sshstatus.Running -eq $False) {
Get-VMHostService | where {$psitem.key -eq "tsm-ssh"} | Start-VMHostService }
Write-Host -Object "Executing Command on $esx"
$output = $plink + " " + $plinkoptions + " " + $root + "@" + $esx + " " + $remoteCommand
$output1 = $plink + " " + $plinkoptions + " " + $root + "@" + $esx + " " + $remoteCommand1
$output2 = $plink + " " + $plinkoptions + " " + $root + "@" + $esx + " " + $remoteCommand2
$message = Invoke-Expression -command $output
$message1 = Invoke-Expression -command $output1
$message2 = Invoke-Expression -command $output2
$message
$message1
$message2
}

<# $message = Invoke-Expression -command $output
$message1 = Invoke-Expression -command $output1
$message
$message1 #>
 

<#some cool stuff if I wanted to do a nested for each. nest the hyps and then nest the commands. 
If you want to execute multiple commands, then group them together as shown below.

C:\>plink root@192.168.101.1 (hostname;crontab -l)
devdb.thegeekstuff.com
no crontab for root

or

A Break statement can include a label. If you use the Break keyword with
a label, Windows PowerShell exits the labeled loop instead of exiting the
current loop
Like so,

foreach ($objectA in @("a", "e", "i")) {
    "objectA: $objectA"
    :outer
    foreach ($objectB in @("a", "b", "c", "d", "e")) {
       if ($objectB -eq $objectA) {
           "hit! $objectB"
           break :outer
       } else { "miss! $objectB" }
    }
}

#Output:
objectA: a
hit! a
objectA: e
miss! a
miss! b
miss! c
miss! d
hit! e
objectA: i
miss! a
miss! b
miss! c
miss! d
miss! e
update of nhpsa dirver and firmware.#>
