# ESXi hosts to migrate from VSS-&gt;VDS
<# 
$vmhost_array = @("934249-hyp05.frank.com",
"934251-hyp06.frank.com",
"934252-hyp07.frank.com",
"934253-hyp08.frank.com",
"934255-hyp09.frank.com",
"934256-hyp10.frank.com",
"934257-hyp11.frank.com",
"934258-hyp12.frank.com",
"934259-hyp13.frank.com",
"934262-hyp14.frank.com",
"934265-hyp15.frank.com",
"934266-hyp16.frank.com") #>
 
$vmhost_array = @("934251-hyp06.frank.com") 
 
# VDS to migrate from
$vds_name = "4702119-ExNet"
$vds = Get-VDSwitch -Name $vds_name
 
# VSS to migrate to
$vss_name = "vSwitch0"
 
# Name of portgroups to create on VSS
$mgmt_name = "Management Network"

 
foreach ($vmhost in $vmhost_array) {
Write-Host "`nProcessing" $vmhost

#need to create vSwitch0
$vswitch =  New-VirtualSwitch -VMHost $vmhost -Name $vss_name
 Write-Host "`nCreated" $vswitch "on" $vmhost
 
# pNICs to migrate to VSS
Write-Host "Retrieving pNIC info for vmnic6,vmnic4"
$vmnic6 = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmnic6"
$vmnic4 = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmnic4"
 
 #remove vmnic4 from the VDS to make it simple to remove just the vds later.
Get-VMhost -Name $vmhost | Get-VMHostNetworkAdapter -Physical -Name $vmnic4 | Remove-VDSwitchPhysicalNetworkAdapter -Confirm:$false -whatif
 
 
# Array of pNICs to migrate to VSS
Write-Host "Creating pNIC array"
$pnic_array = @($vmnic6)
 
# vSwitch to migrate to
$vss = Get-VMHost -Name $vmhost | Get-VirtualSwitch -Name $vss_name
 
# Create destination portgroups
Write-Host "`Creating" $mgmt_name "portrgroup on" $vss_name
$mgmt_pg = New-VirtualPortGroup -VirtualSwitch $vss -Name $mgmt_name
 
 
# Array of portgroups to map VMkernel interfaces (order matters!)
Write-Host "Creating portgroup array"
$pg_array = @($mgmt_pg)
 
# VMkernel interfaces to migrate to VSS
Write-Host "`Retrieving VMkernel interface details for vmk0"
$mgmt_vmk = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmk0"

 
# Array of VMkernel interfaces to migrate to VSS (order matters!)
Write-Host "Creating VMkernel interface array"
$vmk_array = @($mgmt_vmk)
 
# Perform the migration
Write-Host "Migrating from" $vds_name "to" $vss_name"`n"
Add-VirtualSwitchPhysicalNetworkAdapter -VirtualSwitch $vss -VMHostPhysicalNic $pnic_array -VMHostVirtualNic $vmk_array -VirtualNicPortgroup $pg_array  -Confirm:$false
}
 
Write-Host "`nRemoving" $vmhost_array "from" $vds_name
$vds | Remove-VDSwitchVMHost -VMHost $vmhost_array -Confirm:$false
 
Disconnect-VIServer -Server $global:DefaultVIServers -Force -Confirm:$false
