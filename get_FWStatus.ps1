#Connect to vCenter Server
#Connect-VIServer vc

#$vcServer = "hvc"
$vcServer = "vc"

#Connect to vCenter
Connect-VIServer $vcServer | Out-Null


#Get list of ESXi Hosts
#$esxihosts = Get-VMHost -Location <cluster> | Sort-Object -Property Name   
$esxihosts = Get-VMHost   | Sort-Object -Property Name   
$i=0
#$myObject = [PSCustomObject]@{}
$myObject = @()
$data = ForEach ($esxi in $esxihosts) {
    $i++
    
    Write-Progress -Activity "Scanning hosts" -Status ("Host: {0}" -f $esxi.Name) -PercentComplete ($i/$esxihosts.count*100) -Id 0
    
    $ESXfw = (get-esxcli -V2 –vmhost $esxi)
    $a = $ESXFW.network.firewall.ruleset.list.Invoke() | where {$_.Name -eq "syslog"}
    $obj = New-Object -TypeName PSObject
	$obj | Add-Member -MemberType NoteProperty -Name 'cHost' -Value  $esxi.name
	$obj | Add-Member -MemberType NoteProperty -Name 'Service' -Value  $a.Name
    $obj | Add-Member -MemberType NoteProperty -Name 'Enabled' -Value  $a.Enabled
    $myobject += $obj 
}
#$myObject | ForEach-Object{ [pscustomobject]$_ } | Export-CSV -Path 'cloud.csv'
$myObject | select cHost,Service,Enabled |  epcsv $vcserver'_Results'.csv -not
#$data | Export-Csv -NoTypeInformation 'hostSyslogStatusInfo.csv'

#this is an experiment. Close out the connection even if things are good or not. Need to see if it works without "try"
finally
{
#Disconnect from vCenter
Disconnect-VIServer $vcServer -Confirm:$false | Out-Null
}

<#
$myobject | Add-member -MemberType NoteProperty -Name 'NAME2' -Value  $esxiexample.name
PS C:\Users\-a> $a = $ESXFW.network.firewall.ruleset.list.Invoke() | where {$_.Name -eq "syslog"}
PS C:\Users\adu-a> $a

Enabled Name
------- ----
false   syslog


PS C:\Users\-a> $myobject | Add-member -MemberType NoteProperty -Name 'Enabled' -Value  $a.Enabled
PS C:\Users\-a> $myobject | Add-member -MemberType NoteProperty -Name 'service' -Value  $a.Name
PS C:\Users\-a> $myObject


NAME    : VMware.VimAutomation.ViCore.Impl.V1.EsxCli.EsxCliImpl
NAME2   : a2020811fx.adu.dcn
config  : VMware.VimAutomation.ViCore.Impl.V1.EsxCli.EsxCliObjectImpl
Enabled : false
service : syslog



$report = @()
$Distros = Get-DistributionGroup | Where {$_.PrimarySmtpAddress -like $Domain}
    foreach ($Distro in $Distros){
        $DistroMembers = Get-DistributionGroupMember -Identity $Distro.DisplayName
        $SendasCheck = Get-RecipientPermission -Identity $Distro.DisplayName | where {$_.Trustee -ne $Exclude}
        if($SendasCheck -eq $null){"$Distro did not have sendas enabled"}
        else{
            $First = $DistroMembers.FirstName
            $Last = $DistroMembers.LastName
            $Title = $DistroMembers.Title
            $Email = $Distro.primarysmtpaddress
            #add line to object
            
			$obj = New-Object -TypeName PSObject
			$obj | Add-Member -MemberType NoteProperty -Name Firstname -Value $first
			$obj | Add-Member -MemberType NoteProperty -Name LastName -Value $Last
			$obj | Add-Member -MemberType NoteProperty -Name Title -value $Title
			$obj | Add-Member -MemberType NoteProperty -Name EmailAddress -value $Email
			
			$report += $obj
            }

    }
	
	$report | select Firstname,LastName,Title,EmailAddress | epcsv C:\Results.csv -not

Found on Spiceworks: https://community.spiceworks.com/topic/1567146-adding-rows-to-a-psobject?utm_source=copy_paste&utm_campaign=growth
#>
