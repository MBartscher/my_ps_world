[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter()][ValidateScript({$_-is[string]})][string]$strExclude,
 [Parameter()][ValidateScript({$_-is[string]})][string]$strInclude,
 [Parameter()][switch]$OpenErrorLogsFolder
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
 [string]$strPathErrorLogs=-join($strPathScripts,'ErrorLogs')
 if($strPathErrorLogs[$strPathErrorLogs.Length-1]-ne'\'){$strPathErrorLogs+='\'}
 $strExclude+='The(\s|\n)term(\s|\n)''(.|\n)*\\Write-Errorlog_\d{8}-\d{5,6}\.ps1''(\s|\n)is(\s|\n)not(\s|\n)recognized(\s|\n)as(\s|\n)the(\s|\n)name(\s|\n)of(\s|\n)a(\s|\n)cmdlet,(\s|\n)function,(\s|\n)script(\s|\n)file,(\s|\n)or(\s|\n)operable(\s|\n)program\.'
}
process{
 if($Error.Count-gt0){
  MakeSure-PathExists -strPath $strPathErrorLogs
  [string]$strPathErrorLogsExists=$null
  if(Test-Path -Path $strPathErrorLogs){$strPathErrorLogsExists=' exists'}
  else{$strPathErrorLogsExists=' is missing'}
  Write-Debug (-join('"',$strPathErrorLogs,'" ',$strPathErrorLogsExists,'.'))
  Write-Warning (-join($Error.Count,' Errors occured'))
  [int]$iExcluded=$null
  [int]$iCountOld=$Error.Count
  while($Error.Count-gt0){
   if(((($Error[0].ToString()-cnotmatch$strExclude)-and$strExclude)-or(($Error[0].ToString()-cmatch$strInclude)-and$strInclude)-or((-not$strExclude)-and(-not$strInclude)))-and(-not($Error[0]-is[System.Management.Automation.TerminateException]))){
    [string]$strFileDateTimeUniversal=Get-Date -Format FileDateTimeUniversal
    if($Error[0]-is[System.Management.Automation.ErrorRecord]){Export-Clixml -Path (-join($strPathErrorLogs,$strFileDateTimeUniversal,'.xml')) -Force -Depth 5 -InputObject $Error[0]}
    else{-join('Type: ',$Error[0].GetType(),"`n`n",$Error[0]) > (-join($strPathErrorLogs,$strFileDateTimeUniversal,'.txt'))}
   }
   else{$iExcluded++}
   $Error.Remove($Error[0])
   if($iCountOld-le$Error.Count){
    Write-Warning (-join('Infinite loop! "',$MyInvocation.MyCommand.Source,'"'))
    if($Error[0]-and$Error[1]){
     New-Item -Path $strPathErrorLogs -Name (-join('WrtErrLg-InfntLp_',$strFileDateTimeUniversal,'.txt')) -ItemType File -Value (-join($Error[0],($strBreak*2),$Error[1]))
     $Error.RemoveAt(1)
     $Error.RemoveAt(0)
    }
    elseif($Error[0]){
     New-Item -Path $strPathErrorLogs -Name (-join('WrtErrLg-InfntLp_',$strFileDateTimeUniversal,'.txt')) -ItemType File -Value $Error[0]
     $Error.RemoveAt(0)
    }
    else{
     if($MyInvocation.MyCommand.Source){
      Set-PSBreakpoint -Line 17 -Script $MyInvocation.MyCommand.Source|Out-Null
      Invoke-Expression (-join($MyInvocation.MyCommand.Source,' -Debug'))
     }
     else{Pause}
    }
   }
   $iCountOld=$Error.Count
  }
 }
 if($iExcluded-gt0){Write-Warning (-join($iExcluded,' Errors were excluded'))}
}
end{
 if(Test-Path -Path $strPathErrorLogs){
  if($OpenErrorLogsFolder.IsPresent){
   if((Get-Item -Path $strPathErrorLogs).GetFiles().Count-gt0){Invoke-Item -Path $strPathErrorLogs}
   else{Remove-Item -Path $strPathErrorLogs -Force}
  }
  else{if((Get-Item -Path $strPathErrorLogs).GetFiles().Count-eq0){Remove-Item -Path $strPathErrorLogs -Force}}
 }
 $VarName='strFileDateTimeUniversal';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='iExcluded';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='strExclude';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='strInclude';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='OpenErrorLogsFolder';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='strPathErrorLogs';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='iCountOld';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 #$VarName='astrPath';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='strSplittedPath';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 #$VarName='i';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 #$VarName='strPathWorking';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='strPathErrorLogsExists';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='VarName';if(Test-Path -Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
}