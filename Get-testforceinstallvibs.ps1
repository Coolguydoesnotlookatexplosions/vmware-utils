#Test Force install VIBs to bring alternate boot bank up to date.
#updating script found in  https://kb.vmware.com/s/article/2107951 withget-esxcli -V2
#could not get the vib install dryrun to work completely. didnt have a depot to run against. 

$vcServer = "VCENTER"
$cluster = "VDI_Compute01"
Write-Host "root creds"
$esxCred = Get-Credential
#Connect to vCenter
Connect-VIServer $vcServer | Out-Null
#Connect to ESX hosts in cluster
foreach ($esx in Get-Cluster $cluster | Get-VMHost) {
Connect-VIServer $esx -Credential $esxCred | Out-Null
}
#Retrieve the esxcli instances and loop through them
foreach($esxcli in Get-EsxCli -V2) {
#for older version pre-6.3.3 $esxcli.software.vib.list.Invoke() | Where-Object {$_ -like "vxlan"}
#$esxcli.software.vib.get.Invoke(--vibname esx-nsxv)
$esxcli.software.vib.get.Invoke() | Where-Object {$_ -like "esx-nsxv"}
#To ensure VTEPs are correctly instantiated
$esxcli.network.vswitch.dvs.vmware.vxlan.list.Invoke()
$args1 = $esxcli.software.vib.install.CreateArgs()
#$args1.viburl = $null
$args1.dryrun = $true
$args1.depot = $null
#$args1.nosigcheck = $null
$args1.noliveinstall = $true
#$args1.vibname = $null       
#$args1.maintenancemode = $null                     
#$args1.proxy = $null                          
$args1.force = $true

#example, you need to provice all of the values so if not specify use $null $esxcli.software.vib.install("/vmfs/volumes/datastore1/esxui-offline-bundle-3023372.zip",$false,$true,$true,$true,$false,$null,$null, $null)
#$esxcli.software.vib.install(noliveinstall force dryrun depot)
$esxcli.software.vib.install.Invoke($args1)
}

#Disconnect from ESX hosts
foreach ($esx in Get-Cluster $cluster | Get-VMHost) {
Disconnect-VIServer $esx.name -Confirm:$false
}
#Disconnect from vCenter
Disconnect-VIServer $vcServer -Confirm:$false | Out-Null
