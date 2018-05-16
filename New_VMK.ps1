#in github the example ipcsv is called NEW_vmk_IPslist.csv
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
