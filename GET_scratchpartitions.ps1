#needed to check which hosts in a  VC had /tmp as their scratch partitions
# found  LucD had already come up with something. 
#https://communities.vmware.com/thread/473438
#put my own tweaks on it. just changing the directory 

#learned about https://code.vmware.com/doc/preview?id=6330#/doc/Get-AdvancedSetting.html
#availble contstants to look up from get-advancedsetting
#ClusterHA
#VM
#ClusterDRS
#VMHost
#DatastoreClusterSdrs
#VIServer

$scratch="ScratchConfig.ConfiguredScratchLocation"
&{foreach($esx in Get-VMHost){
  Get-AdvancedSetting -Entity $esx -Name $scratch |
  Select @{N="ESXi";E={$esx.Name}},Value
}} | ConvertTo-Html | Out-File C:\temp\hbtvct14_report.html

Invoke-Item c:\temp\hbtvct14_report.html
<# 
#if you want to search for stuff
do something like this
PS C:\> $as = Get-AdvancedSetting -Entity $esx -Name *scratch*
PS C:\> $as

Name                 Value                Type                 Description
----                 -----                ----                 -----------
ScratchConfig.Cur... /tmp/scratch         VMHost
ScratchConfig.Con...                      VMHost

OR
-Name net*tcp*

what's neat is to a | gm to get-members
then can do a select to pick out those members you just looked up.
PS C:\> $as = Get-AdvancedSetting -Entity $esx -Name *scratch* | Select type
PS C:\> $as

  Type
  ----
VMHost
VMHost
What are the N and E in the select?
N is Name and E is Expression (you can also spell out Name and Expression). Specifying a hashtable as a parameter to Select-Object creates a calculated property. See help Select-Object for some examples

You are looking at the short hand for the keys of a calculated property. "N" is short for Name. "L" or Label is also used in place of Name. "E" of course is for Expression.
They are used when you want to manipulate existing properties or as a simple way to add properties. It is by no means the only way.
So for our report we are taking the NAME colume and renaming it to esxi and the expression is the name of each host
https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-powershell-1.0/ff730948(v=technet.10)
#>
