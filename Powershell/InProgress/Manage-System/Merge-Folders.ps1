[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath,
 [Parameter()][AllowNull()][ValidateScript({if($_-eq$null){$true}else{Test-Path -Path $_}})][string]$strNewArchive
)
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
 function CleanUp-DailyFolders{
  [CmdletBinding(SupportsShouldProcess)]
  param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath)
  begin{}
  process{}
  end{}
 }
}
process{
 if($strNewArchive){
  Write-Verbose 'Rename new archive'
  Rename-Item -Path $strNewArchive -NewName 'Archive' -Force
  $strNewArchive-match'[^\\]*$'|Out-Null
  $strNewArchive=$strNewArchive-replace($Matches[0],'Archive')
  Write-Verbose 'Rename files in archive with time stamp (LstWrtTmUTC)'
  [System.IO.FileInfo[]]$aflinfFilesInArchive=Get-ChildItem -Path $strNewArchive -File -Force -Recurse
  [int]$iRem=0
  for([int]$i=0;$i-lt$aflinfFilesInArchive.Count;$i++){
   if($VerbosePreference){$iRem=Show-PercentPoints -intCount $i -intMax $aflinfFilesInArchive.Count -intOld $iRem}
   if($aflinfFilesInArchive[$i].BaseName-notmatch$strLstWrtTmUTCMask){Rename-Item -Path $aflinfFilesInArchive[$i].FullName -NewName ($aflinfFilesInArchive[$i].Name-replace($aflinfFilesInArchive[$i].BaseName,(-join($aflinfFilesInArchive[$i].BaseName,'_',($aflinfFilesInArchive[$i].LastWriteTimeUtc-replace('-|:','')-replace(' ','-'))))))}
  }
  if($VerbosePreference){Write-Host}
 }
 [System.IO.DirectoryInfo[]]$adrinfDailyFolders=Get-ChildItem -Path $strFolderPath -Directory -Force|Where-Object{$_.BaseName-match'^\d{4}-\d{2}-\d{2}_DASI$'}
 for([int]$i=0;$i-lt$adrinfDailyFolders.Count;$i++){
  Write-Verbose 'get daily folders'
  Write-Verbose (-join($i,'/',$adrinfDailyFolders.Count))
  [System.IO.FileInfo[]]$aflinfFilesInDailyFolder=Get-ChildItem -Path $adrinfDailyFolders[$i].FullName -File -Force -Recurse
  $iRem=0
  for([int]$k=0;$k-lt$aflinfFilesInDailyFolder.Count;$k++){
   if($VerbosePreference){$iRem=Show-PercentPoints -intCount $k -intMax $aflinfFilesInDailyFolder.Count -intOld $iRem}
   if($aflinfFilesInDailyFolder[$k].BaseName-notmatch$strLstWrtTmUTCMask){Rename-Item -Path $aflinfFilesInDailyFolder[$k].FullName -NewName ($aflinfFilesInDailyFolder[$k].Name-replace($aflinfFilesInDailyFolder[$k].BaseName,(-join($aflinfFilesInDailyFolder[$k].BaseName,'_',($aflinfFilesInDailyFolder[$k].LastWriteTimeUtc-replace('-|:','')-replace(' ','-'))))))}
  }
  if($VerbosePreference){Write-Host}
 }
}
end{
 $Matches=$null
 $aflinfFilesInArchive=$null
 $iRem=$null
 $i=$null
 Write-Errorlog
}