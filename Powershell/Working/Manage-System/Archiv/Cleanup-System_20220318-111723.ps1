[CmdletBinding()]
param()
begin{if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MySettings.ps1}}
process{
 if(Test-Path -Path 'C:\$RECYCLE.BIN\'){
  Write-Verbose 'C:\$RECYCLE.BIN\'
  Clear-RecycleBin -Force
 }
 if(Test-Path -Path $env:temp){
  Write-Verbose '$env:temp'
  Remove-Item -path (-join($env:temp,'\*')) -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\Temp\'){
  Write-Verbose 'C:\Temp\'
  Remove-Item -path 'C:\Temp\*' -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\Users\m.bartscher.PROMATIC\Documents\Automatisierung\TIA\Temp\'){
  Write-Verbose 'C:\Users\m.bartscher.PROMATIC\Documents\Automatisierung\TIA\Temp\'
  Remove-Item -path 'C:\Users\m.bartscher.PROMATIC\Documents\Automatisierung\TIA\Temp\*' -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\tmp\'){
  Write-Verbose 'C:\tmp\'
  Remove-Item -path 'C:\tmp\*' -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\Users\m.bartscher\Downloads\simatic\'){
  Write-Verbose 'C:\Users\m.bartscher\Downloads\simatic\'
  Remove-Item -path 'C:\Users\m.bartscher\Downloads\simatic\*' -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\Users\m.bartscher\Documents\Automation\'){
  Write-Verbose 'C:\Users\m.bartscher\Documents\Automation\*.backup'
  Remove-Item -path 'C:\Users\m.bartscher\Documents\Automation\*.backup' -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\DASI'){
  Write-Verbose 'C:\DASI'
  Get-ChildItem -Path 'C:\DASI' -File -Force -Recurse|Where-Object{($_.PSChildName-like'~$*')-or($_.PSChildName-like'*.tmp'-or$_.Attributes.HasFlag([System.IO.FileAttributes]::Temporary))}|Remove-Item -Force -ErrorAction SilentlyContinue
  Get-ChildItem -Path 'C:\DASI' -Directory -Force -Recurse|Where-Object{$_.GetFiles().Count-eq0-and$_.GetDirectories().Count-eq0}|Remove-Item -Force -ErrorAction SilentlyContinue
 }
}
end{Write-Errorlog -strExclude 'Cannot remove item (.|\n)*: (The process cannot access the file (.|\n)* because it is being used by another process\.|The directory is not empty\.|Access to the path is denied\.)|Access to the path (.|\n)* is denied\.'}