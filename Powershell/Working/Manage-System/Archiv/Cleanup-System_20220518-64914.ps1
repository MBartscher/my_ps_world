[CmdletBinding()]
param()
begin{
 function Get-MySettings{[CmdletBinding(SupportsShouldProcess)]
   param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath)
   begin{}
   process{
    [System.IO.DirectoryInfo]$drinfFolder=Get-Item -Path $strFolderPath -Force
    while($drinfFolder.Parent.FullName-ne$null-and-not$strPathScripts){
     Write-Debug (-join('next folder:',"`t",$drinfFolder.FullName))
     [System.IO.FileInfo[]]$aflinfContainedScripts=Get-ChildItem -Path $drinfFolder.FullName -Filter '*.ps1' -Force -File|Where-Object{$_.FullName-notmatch'Archiv'}
     if($aflinfContainedScripts.Count-gt0){
      for([int]$i=0;$i-lt$aflinfContainedScripts.Count;$i++){
       Write-Debug (-join('aflinfContainedScripts[',$i,']:',"`t",$aflinfContainedScripts[$i].BaseName))
       if($aflinfContainedScripts[$i].BaseName-eq'MySettings'){
        Write-Debug (-join('found "MySettings.ps1":',"`t",$aflinfContainedScripts[$i].FullName))
        Invoke-Expression -Command (-join('& ''',$aflinfContainedScripts[$i].FullName,''''))
        break
       }
      }
     }
     Write-Debug (-join('parent of current folder:',"`t",$drinfFolder.Parent.FullName))
     if($drinfFolder.Parent.FullName-ne$null){$drinfFolder=Get-Item -Path $drinfFolder.Parent.FullName -Force}
    }
    if($aflinfContainedScripts.Count-gt0){if($aflinfContainedScripts[$i].BaseName-ne'MySettings'){Write-Warning (-join('"MySettings.ps1" not found. Pls execute script "Set-MySettings"!'))}}
   }
   end{}
  }
  if(-not$strPathScripts){
   [string[]]$astrPath=$MyInvocation.MyCommand.Source.Split('\')
   if($DebugPreference){
    [string]$strSplittedPath=$null
    for($i=0;$i-lt$astrPath.Count;$i++){$strSplittedPath+=-join("`t",$astrPath[$i],"`n")}
   }
   Write-Debug (-join("`n",'MyCommand.Source: ',$MyInvocation.MyCommand.Source,"`n",'astrPath:',"`n",$strSplittedPath))
   for([int]$i=$astrPath.Count-1;$i-ge0;$i--){
    if($astrPath[$i]-eq'InProgress'){
     $astrPath[$i]='Working'
     $i++
    }
    elseif($astrPath[$i]-ne'Working'){
     Write-Debug (-join("`n",'astrPath[$i]: ',$astrPath[$i],"`n"))
     $astrPath=$astrPath-ne$astrPath[$i]
     if($DebugPreference){
      [string]$strSplittedPath=$null
      for($i=0;$i-lt$astrPath.Count;$i++){$strSplittedPath+=-join("`t",$astrPath[$i],"`n")}
     }
    }
    else{
     [string]$strPathWorking=$null
     for($i=0;$i-lt$astrPath.Count;$i++){$strPathWorking+=-join($astrPath[$i],'\')}
     Write-Debug (-join("`n",'strPathWorking: ',$strPathWorking,"`n"))
     break
    }
    Write-Debug (-join("`n",'astrPath: ',"`n",$strSplittedPath))
    if($astrPath.Count-eq0){
     Write-Warning 'Folder "Working" not found.'
     Pause
     Exit
    }
   }
   if($strPathWorking){Get-MySettings -strFolderPath $strPathWorking}
   else{
    Write-Warning 'Something went wrong...'
    if((Read-Host 'Start debugging? (yes=y, no=n): ')-eq'y'){Invoke-Expression -Command (-join('& ''',$MyInvocation.InvocationName,''' -debug'))}
   }
  }
}
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
 if(Test-Path -Path 'C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\Automation'){
  Write-Verbose 'C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\Automation*.backup'
  Remove-Item -path 'C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\Automation*.backup' -Force -Recurse -ErrorAction SilentlyContinue
 }
 if(Test-Path -Path 'C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\DASI'){
  Write-Verbose 'C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\DASI'
  Get-ChildItem -Path 'C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\DASI' -File -Force -Recurse|Where-Object{($_.PSChildName-like'~$*')-or($_.PSChildName-like'*.tmp'-or$_.Attributes.HasFlag([System.IO.FileAttributes]::Temporary))}|Remove-Item -Force -ErrorAction SilentlyContinue
#  Get-ChildItem -Path 'C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\DASI' -Directory -Force -Recurse|Where-Object{$_.GetFiles().Count-eq0-and$_.GetDirectories()-eq0}|Remove-Item -Force -ErrorAction SilentlyContinue
 }
}
end{Write-Errorlog -strExclude 'Cannot remove item (.|\n)*: (The process cannot access the file (.|\n)* because it is being used by another process\.|The directory is not empty\.|Access to the path is denied\.)|Access to the path (.|\n)* is denied\.|The system cannot find the path specified'}