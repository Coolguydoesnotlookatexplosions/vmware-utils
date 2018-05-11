#remove servicenet vds

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
"934266-hyp16.frank.com")
$vds_name = "4702119-ServiceNet"
$vds = Get-VDSwitch -Name $vds_name
Write-Host "`nRemoving" $vmhost_array "from" $vds_name
$vds | Remove-VDSwitchVMHost -VMHost $vmhost_array -Confirm:$false
