<# #this is to add vmk for customer backup and provisioning traffic on the Customer DVS. 

$MyFile = Import-CSV ips.csv
$wchosts = Get-VMHost -State connected | Sort-Object name
$Westportgroup="Exnet-Prov_Backup_VLAN1027"
$VS = "4702119-ExNet"
#$VS = "Management_10dot"
$SubnetMask = "255.255.255.0"
$hostarrynumber = 0

ForEach ($i in $MyFile) {
      New-VMHostNetworkAdapter -VMHost $wchosts[$hostarrynumber] -PortGroup $Westportgroup -VirtualSwitch $VS -IP $i.ips -SubnetMask $SubnetMask
$hostarrynumber+=1
    }


#need to remove the vmk4
$network = Get-VDPortGroup -Name Exnet-Prov_Backup_VLAN1027  | Get-VMHostNetworkAdapter
Remove-VMHostNetworkAdapter $network
 #>

#version 2 of adding provisioning vmk
$MyFile = Import-CSV ips.csv
#$MyFile = Import-CSV testip.csv
$wchosts = Get-VMHost -State connected -Location 4702119 | Sort-Object name
#$wchosts = Get-VMHost -name 937822-hyp01.mv.rackspace.com

$Westportgroup="Exnet-Prov_Backup_VLAN1027"
$VS = "4702119-ExNet"
$SubnetMask = "255.255.255.0"
$hostarrynumber = 0

##ESXCLI##
ForEach ($i in $MyFile) {

$esxcli = Get-EsxCli -VMhost $wchosts[$hostarrynumber] -V2
Write-host Creating standard switches -ForegroundColor Yellow
#create VS
$esxcli.network.vswitch.standard.add.Invoke(@{vswitchname="myvs"}) 
#create pg on VS
$esxcli.network.vswitch.standard.portgroup.add.Invoke(@{portgroupname = "VM Network";vswitchname="myvs" }) 
$currenthost = $wchosts[$hostarrynumber]

##Create netstack and add VMkernel adapters##
write-host Create Provisioning TCP/IP stack and add Provisioning VMkernel ports -ForegroundColor Blue
$esxcli.network.ip.netstack.add.Invoke(@{netstack = "vSphereProvisioning"})
$esxcli.network.ip.interface.add.Invoke(@{interfacename = "vmk4"; portgroupname = "VM Network"; netstack = "vSphereProvisioning"})
$esxcli.network.ip.interface.ipv4.set.Invoke(@{interfacename  = "vmk4"; netmask = $SubnetMask; gateway = "10.71.172.1"; type = "static";ipv4 = $i.ips})

#migrate to dvs
##Migrate Provisioning vmk to Distibuted Portgroup##
$destinationprovisioningpg = Get-VDPortgroup -Name $Westportgroup
write-host Migrate Provisioning VMkernel to $VS on $wchosts[$hostarrynumber] -ForegroundColor Yellow
$dvportgroup = Get-VDPortgroup -Name $destinationprovisioningpg -VDSwitch $VS
#$vmk = Get-VMHostNetworkAdapter -VMHost $wchosts -VMKernel -Name vmk4
#$vmk = Get-VMHost $wchosts | Get-VMHostNetworkAdapter -VMKernel | ?{$_.Name -match "vmk4"}
#$vmk = Get-VMHostNetworkAdapter -VMHost $wchosts | Where-Object{$_.Name -match "vmk4"}
#Write-Host this is the vmk that is migrating $vmk
NEED TO ADD A SLEEP HERE OF LIKE 10 SECONDS OTHERWISE YOU GET A MESSAGE THAT THE VMK WAS NOT FOUND
#Set-VMHostNetworkAdapter -PortGroup $dvportgroup -VirtualNic (Get-VMHostNetworkAdapter -VMHost $currenthost | Where-Object{$_.Name -match "vmk4"}) -Confirm:$false | Out-Null
Set-VMHostNetworkAdapter -PortGroup $dvportgroup -VirtualNic (Get-VMHostNetworkAdapter -VMHost $currenthost -Name "vmk4") -Confirm:$false | Out-Null


#delete  VS
##Remove Virtual Standard Switch##
Write-Host Removing the Virtual Standard Switch -ForegroundColor Yellow
$esxcli.network.vswitch.standard.remove.Invoke(@{vswitchname="myvs"})
$hostarrynumber+=1
}




<# now need to edit the vmk since you cant set the ip 
$nic =  New-VMHostNetworkAdapter -VMHost 10.23.112.234 -PortGroup PortGroup -VirtualSwitch
$vswitch -IP 10.23.123.234 -SubnetMask 255.255.254.0

Set-VMHostNetworkAdapter -VirtualNIC $nic -IP 10.23.112.245 -SubnetMask 255.255.255.0 -Mtu 4000


$host1 
$esxtest =  Get-EsxCli -VMhost (Get-VMHost $host1 ) -V2


$myVirtualSwitch = Get-VirtualSwitch -VMHost $wchosts[$hostarrynumber]  -Standard 
#-Name "myvs"
$vmk= Get-VMHostNetworkAdapter -VirtualSwitch $myVirtualSwitch -name vmk4
#>
