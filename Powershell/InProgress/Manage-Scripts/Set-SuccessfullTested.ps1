[CmdletBinding(SupportsShouldProcess)]
param()
begin{
 [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")|Out-Null
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
 $fldlgSelectFile=New-Object System.Windows.Forms.OpenFileDialog
 $fldlgSelectFile.InitialDirectory='C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\DASI\Skripte\Powershell\InProgress'
 $fldlgSelectFile.Filter="ps1-Files (*.ps1)|*.ps1"
 $fldlgSelectFile.Multiselect=$false
 $fldlgSelectFile.ShowDialog()|Out-Null
 if($fldlgSelectFile.FileName){[System.IO.FileSystemInfo]$flinfScript=Get-Item -Path $fldlgSelectFile.FileName}
 else{exit}
}
process{
 MakeSure-PathExists -strPath (($flinfScript.FullName-replace($flinfScript.Name,''))-replace('InProgress','Working'))
 Copy-Item -Path $flinfScript.FullName -Destination ($flinfScript.FullName-replace('InProgress','Working')-replace($flinfScript.Name,(-join($flinfScript.Name.Substring(0,$flinfScript.Name.IndexOf('.')),'_',($flinfScript.LastWriteTimeUtc-replace('[:-]','')-replace(' ','-')),$flinfScript.Extension)))) -Force
 [System.IO.FileSystemInfo[]]$aflinfSameScriptDiffVers=Get-ChildItem -Path ($flinfScript.FullName-replace('InProgress','Working')-replace($flinfScript.Name,'')) -File -Force|Where-Object{$_.BaseName-match$flinfScript.BaseName}|Sort-Object -Descending -Property LastWriteTimeUtc
 if($aflinfSameScriptDiffVers.Count-gt1){
  MakeSure-PathExists -strPath (-join((($flinfScript.FullName-replace($flinfScript.Name,''))-replace('InProgress','Working')),'Archiv'))
  for($i=1;$i-lt$aflinfSameScriptDiffVers.Count;$i++){Move-Item -Path $aflinfSameScriptDiffVers[$i].FullName -Destination ($aflinfSameScriptDiffVers[$i].FullName-replace($aflinfSameScriptDiffVers[$i].Name,'Archiv\')) -Force}
 }
 Invoke-Item -Path ($flinfScript.FullName-replace($flinfScript.Name,'')-replace('InProgress','Working'))
 [System.IO.FileInfo]$flinfSetMySettings=Get-ChildItem -Path (-join($strPathScripts,'\Manage-Scripts')) -Filter '*Set-MySettings*' -Force -File
 Invoke-Expression -Command (-join('& ''',$flinfSetMySettings.FullName,''' -strFolderPath ''',$strPathScripts,''''))
}
end{
 $VarName='fldlgSelectFile';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='flinfScript';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='aflinfSameScriptDiffVers';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='i';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='flinfSetMySettings';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 #$VarName='astrPath';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 #$VarName='strPathWorking';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='strSplittedPath';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='VarName';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 Write-Errorlog
}