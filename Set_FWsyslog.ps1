$fwstatus = Import-Csv .\Results.csv
$a= $fwstatus.Where({$_.Enabled -eq 'false'})

foreach ($fix in $a ) {
 $ESXfw = (get-esxcli -V2 –vmhost $a.cHost)
 @config
 $ESXFW.network.firewall.rulset.set.Invoke

 $ESXFW.network.firewall.refresh.Invoke()

#To modify a host configuration, run the following command to specify the options to change.
#should be configured already through loginsight
#esxcli system syslog config set --loghost=tcp|udp|ssl://log_insight-host:514
#Note You must use udp or tcp, but not both.
#esxcli system syslog config set --loghost=udp://vrlog.local:514
#esxcli system syslog config set --loghost=udp://vrlog.local:514


#To ensure that the ESXi firewall is configured to allow syslog traffic to leave the host, run the following commands.

esxcli network firewall ruleset set --ruleset-id=syslog --enabled=true
esxcli network firewall refresh

#Load the new configuration by running the 
esxcli system syslog reload


}




```$obj = New-Object -TypeName PSObject
    $obj | Add-Member -MemberType NoteProperty -Name 'cHost' -Value  $esxi.name
    $obj | Add-Member -MemberType NoteProperty -Name 'Service' -Value  $a.Name
    $obj | Add-Member -MemberType NoteProperty -Name 'Enabled' -Value  $a.Enabled```

That is more or less the same as :
```$obj = "" | Select cHost, Service, Enabled
    $obj.cHost = $esxi.name
    $obj.Service = $a.Name
    $obj.Enabled = $a.Enabled```



    

    <#
    PS C:\Users\fmarr> $fwstatus.Where({$_.Enabled -eq 'false'})

cHost  Service Enabled
-----  ------- -------
hb702  syslog  false
hb7023 syslog  false
s10418 syslog  false
s10410 syslog  false
s1041  syslog  false
#>


$esxhost = 'hb7022'
$esxCred = Get-Credential
#Connect to ESX hosts in cluster
Connect-VIServer $esxhost -Credential $esxCred | Out-Null



$ESXfw.ruleset.set ($true, $true, "syslog")
$ESXFW.network.firewall.rulset.set. ($true, $true, "syslog"0
