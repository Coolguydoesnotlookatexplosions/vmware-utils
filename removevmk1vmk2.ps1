# remove vmk1 and 1 from hosts 
$vmhost_array = @("934249-hyp05.e.com",
"934251-hyp06.e.com",
"934252-hyp07.e.com",
"934253-hyp08.e.com",
"934255-hyp09.e.com",
"934256-hyp10.e.com",
"934257-hyp11.e.com",
"934258-hyp12.ce.com",
"934259-hyp13.e.com",
"934262-hyp14.e.com",
"934265-hyp15.e.com",
"934266-hyp16.e.com")
 



Foreach ($vmhost in $vmhost_array){
    # VMkernel interfaces to migrate to VSS
Write-Host "`Retrieving VMkernel interface details for vmk1,vmk2"
       $storage_vmk = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmk1"
$vmotion_vmk = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmk2"
Remove-VMHostNetworkAdapter -Nic $storage_vmk -Confirm:$false  -whatif
Remove-VMHostNetworkAdapter -Nic $vmotion_vmk -Confirm:$false  -whatif
        }
