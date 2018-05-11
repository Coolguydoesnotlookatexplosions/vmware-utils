# remove vmk1 and 1 from hosts 
$vmhost_array = @("934249-hyp05.mv.rackspace.com",
"934251-hyp06.mv.rackspace.com",
"934252-hyp07.mv.rackspace.com",
"934253-hyp08.mv.rackspace.com",
"934255-hyp09.mv.rackspace.com",
"934256-hyp10.mv.rackspace.com",
"934257-hyp11.mv.rackspace.com",
"934258-hyp12.mv.rackspace.com",
"934259-hyp13.mv.rackspace.com",
"934262-hyp14.mv.rackspace.com",
"934265-hyp15.mv.rackspace.com",
"934266-hyp16.mv.rackspace.com")
 
 
<# $vmhost_array = @("934170-hyp01.mv.rackspace.com",
"934245-hyp02.mv.rackspace.com",
"934247-hyp03.mv.rackspace.com") #>


Foreach ($vmhost in $vmhost_array){
    # VMkernel interfaces to migrate to VSS
Write-Host "`Retrieving VMkernel interface details for vmk1,vmk2"
       $storage_vmk = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmk1"
$vmotion_vmk = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmk2"
Remove-VMHostNetworkAdapter -Nic $storage_vmk -Confirm:$false  -whatif
Remove-VMHostNetworkAdapter -Nic $vmotion_vmk -Confirm:$false  -whatif
        }
