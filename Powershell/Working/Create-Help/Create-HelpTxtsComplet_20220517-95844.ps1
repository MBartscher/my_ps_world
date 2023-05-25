[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath,
 [Parameter()][switch]$updateHelp
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
 function Show-Percent{
  param(
   [parameter(Mandatory=$true)][int32]$intCount,
   [parameter(Mandatory=$true)][int32]$intMax,
   [parameter(Mandatory=$true)][int32]$intOld
  )
  [int32]$intPercent=0
  $intPercent=$intCount/$intMax*100
  if($intPercent-gt$intOld){Write-Host $intPercent '%'}
  $intCount=$null
  $intMax=$null
  $intOld=$null
  return $intPercent
 }
}
process{
 if($updateHelp.IsPresent){
  Write-Host '#=> update Help'
  Update-Help -Force
 }
 $Aliases=@()
 [int32]$intRem=0
 $HelpList=Get-Help *
 for($i=0;$i-lt$HelpList.Count;$i++){
  $intRem=Show-Percent -intCount $i -intMax $HelpList.Count -intOld $intRem
  if($HelpList[$i].Category-eq"Alias"){$Aliases+=$HelpList[$i]}
  else{Create-HelpTxtFile -strFolderPath $strFolderPath -strHelpTopic $HelpList[$i].Name}
 }
 if($strFolderPath[$strFolderPath.Length-1]-ne'\'){$strFolderPath+='\'}
 $Aliases > (-join($strFolderPath,'Aliases.txt'))
 cmd.exe /? > (-join($strFolderPath,'cmd.exe.txt'))
}
end{
 $Aliases=$null
 $intRem=$null
 $HelpList=$null
 $i=$null
 [System.GC]::Collect()
 Write-Errorlog -strExclude 'Unable(\s|\n)to(\s|\n)find(\s|\n)repository(\s|\n)''.*''\.(\s|\n)Use(\s|\n)Get-PSRepository(\s|\n)to(\s|\n)see(\s|\n)all(\s|\n)available(\s|\n)repositories\.'
}