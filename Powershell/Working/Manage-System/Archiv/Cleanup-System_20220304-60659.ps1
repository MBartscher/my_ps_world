[CmdletBinding()]
param()
begin{
 $MyInvocation.MyCommand.Name-match'^.[^_\d\.]*'|Out-Null
 if(-not(Test-Path -Path (-join('Alias:',$Matches[0])))){C:\DASI\Skripte\Powershell\Working\Manage-Files\Set-Aliases_20220303-150045.ps1 -strFolderPath C:\DASI\Skripte\Powershell\Working}
}
process{
 if(Test-Path -Path 'C:\$RECYCLE.BIN\'){
  Write-Host 'C:\$RECYCLE.BIN\'
  Remove-Item -path 'C:\$RECYCLE.BIN\*' -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path $env:temp){
  Write-Host '$env:temp'
  Remove-Item -path (-join($env:temp,'\*')) -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\Temp\'){
  Write-Host 'C:\Temp\'
  Remove-Item -path 'C:\Temp\*' -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\Users\m.bartscher.PROMATIC\Documents\Automatisierung\TIA\Temp\'){
  Write-Host 'C:\Users\m.bartscher.PROMATIC\Documents\Automatisierung\TIA\Temp\'
  Remove-Item -path 'C:\Users\m.bartscher.PROMATIC\Documents\Automatisierung\TIA\Temp\*' -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\tmp\'){
  Write-Host 'C:\tmp\'
  Remove-Item -path 'C:\tmp\*' -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\Users\m.bartscher\Downloads\simatic\'){
  Write-Host 'C:\Users\m.bartscher\Downloads\simatic\'
  Remove-Item -path 'C:\Users\m.bartscher\Downloads\simatic\*' -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\Users\m.bartscher\Documents\Automation\'){
  Write-Host 'C:\Users\m.bartscher\Documents\Automation\*.backup'
  Remove-Item -path 'C:\Users\m.bartscher\Documents\Automation\*.backup' -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\DASI'){
  Write-Host 'C:\DASI'
  Get-ChildItem -Path 'C:\DASI' -File -Force -Recurse|Where-Object{($_.PSChildName-like'~$*')-or($_.PSChildName-like'*.tmp')}|Remove-Item -Force -ErrorAction SilentlyContinue
  Get-ChildItem -Path 'C:\DASI' -Directory -Force -Recurse|Where-Object{$_.GetFiles().Count-eq0-and$_.GetDirectories().Count-eq0}|Remove-Item -Force -ErrorAction SilentlyContinue
 }
}
end{
 Write-Errorlog -strFolderPath ($MyInvocation.MyCommand.Path-replace($MyInvocation.MyCommand.Name,'')) -strExclude 'Cannot remove item (.|\n)*: (The process cannot access the file (.|\n)* because it is being used by another process\.|The directory is not empty\.|Access to the path is denied\.)'
}