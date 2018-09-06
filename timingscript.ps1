#some tips here
#https://www.pluralsight.com/blog/tutorials/measure-powershell-scripts-speed
#this method you can still get the output. 

$sw = [Diagnostics.Stopwatch]::StartNew()
.\do_something.ps1
$sw.Stop()
$sw.Elapsed
