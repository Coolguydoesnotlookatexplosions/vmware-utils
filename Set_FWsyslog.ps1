#$fwstatus = Import-Csv .\Results.csv
Write-host "This many items in list = " $fwstatus.length 
$a= $fwstatus.Where({$_.Enabled -eq 'false'})
Write-host "Will Remediate" $a.count "hosts"
Start-Sleep -s 5
#$vcServer = VC
#Connect to vCenter
Connect-VIServer $vcServer | Out-Null


foreach ($fix in $a.chost ) {
$ESXfw = (get-esxcli -V2 –vmhost $fix)
$argsb = $ESXFW.network.firewall.ruleset.set.CreateArgs()
#$args = @(rulesetid, allowedall,enabled )
$argsb.rulesetid = "syslog"
#don't need this one. create an error $argsb.allowedall = $true
$argsb.enabled = $true
$ESXFW.network.firewall.ruleset.set.Invoke($argsb)
$ESXfw.network.firewall.refresh.invoke()
$outmessage = $ESXFW.network.firewall.ruleset.list.Invoke() | where {$_.Name -eq "syslog"}
write-host $outmessage $fix

}


#Disconnect from vCenter
Disconnect-VIServer $vcServer -Confirm:$false | Out-Null
   


