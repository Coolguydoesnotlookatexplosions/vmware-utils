#needed to check which hosts in a  VC had /tmp as their scratch partitions
# found  LucD had already come up with something. 
#https://communities.vmware.com/thread/473438
#put my own tweaks on it. just changing the directory 

$scratch="ScratchConfig.ConfiguredScratchLocation"
&{foreach($esx in Get-VMHost){
  Get-AdvancedSetting -Entity $esx -Name $scratch |
  Select @{N="ESXi";E={$esx.Name}},Value
}} | ConvertTo-Html | Out-File C:\temp\hbtvct14_report.html

Invoke-Item c:\temp\hbtvct14_report.html

#learned about https://code.vmware.com/doc/preview?id=6330#/doc/Get-AdvancedSetting.html
