[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter()][switch]$NextErrorlog
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
 function Test-ErrorLogsFolderExists{
  [CmdletBinding(SupportsShouldProcess)]
  param([parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string]$strPathErrorLogs)
  begin{}
  process{
   if(-not(Test-Path -Path $strPathErrorLogs)){
    Write-Host 'No errorlogs to analyse.'
    pause
    exit
   }
  }
  end{}
 }
 function Test-ErrorLogFilesExist{
  [CmdletBinding(SupportsShouldProcess)]
  param([parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string]$strPathErrorLogs)
  begin{}
  process{
   if(Test-Path -Path $strPathErrorLogs){if((Get-ChildItem -Path $strPathErrorLogs).Count-eq0){Remove-Item -Path $strPathErrorLogs -Force}}
   Test-ErrorLogsFolderExists -strPathErrorLogs $strPathErrorLogs
  }
  end{}
 }
 [string]$strPathErrorLogs=-join($strPathScripts,'ErrorLogs')
 if($strPathErrorLogs[$strPathErrorLogs.Length-1]-ne'\'){$strPathErrorLogs+='\'}
 Test-ErrorLogsFolderExists -strPathErrorLogs $strPathErrorLogs
}
process{
 [System.IO.FileInfo]$flinfErrorLog=(Get-FilesFrmFolderSrtdByLstWrTmUTC -strFolderPath $strPathErrorLogs)[0]
 if($NextErrorlog.IsPresent){
  Remove-Item -Path ($flinfErrorLog.FullName)
  Test-ErrorLogFilesExist -strPathErrorLogs $strPathErrorLogs
  $flinfErrorLog=(Get-FilesFrmFolderSrtdByLstWrTmUTC -strFolderPath $strPathErrorLogs)[0]
 }
 switch($flinfErrorLog.Extension){
  '.xml'{
   $ErrorLog=Import-Clixml -Path $flinfErrorLog.FullName
   if($Error.Count-gt0-and$Error[0].ToString()-match'Data at the root level is invalid.|Unexpected end of file has occurred.'-and$ErrorLog.ErrorCategory_Activity-match'Import-Clixml'){
    Write-Warning (-join($Error[0].ToString(),$strBreak,'Filename: ',$strBreak,$strTab,$flinfErrorLog.FullName))
    Invoke-Item -Path $flinfErrorLog.FullName
    pause
   }
   Write-Host $strBreak,$flinfErrorLog.BaseName,$strBreak
   Write-Warning (-join($strBreak,$ErrorLog.ToString(),$strBreak))
   if($ErrorLog.ErrorCategory_Activity){Write-Host 'ErrorCategory_Activity:',$strTab,$ErrorLog.ErrorCategory_Activity,$strBreak}
   if($ErrorLog.ErrorCategory_Message){Write-Host 'ErrorCategory_Message:',$strTab,$ErrorLog.ErrorCategory_Message,$strBreak}
   if($ErrorLog.InvocationInfo.ScriptName){
    Write-Host 'InvocationInfo.ScriptName:',$strBreak,$strTab,$ErrorLog.InvocationInfo.ScriptName,$strBreak
    if($ErrorLog.InvocationInfo.ScriptName-match'\\Working\\'){
     $ErrorLog.InvocationInfo.ScriptName-match'_\d{8}-\d{5,6}'|Out-Null
     if(Test-Path -Path ($ErrorLog.InvocationInfo.ScriptName-replace('Working','Inprogress')-replace($Matches[0],''))){$psISE.CurrentPowerShellTab.Files.Add($ErrorLog.InvocationInfo.ScriptName-replace('Working','Inprogress')-replace($Matches[0],''))|Out-Null}
     if($Error.Count-gt0-and$Error[0].ToString()-eq'You cannot call a method on a null-valued expression.'-and$Error[0].InvocationInfo.ScriptName-match(-join('C:\DASI\Skripte\Powershell\Working\Manage-Scripts\Analyse-Errorlog',$strLstWrtTmUTCMask,'.ps1'))-and$Error[0].InvocationInfo.ScriptLineNumber-eq56){
      Write-Host 'ScriptName:',$ErrorLog.InvocationInfo.ScriptName
      if($Matches){
       Write-Host '$Matches[0]:',$Matches[0]
       Write-Host 'altered ScriptName:',$ErrorLog.InvocationInfo.ScriptName-replace('Working','Inprogress')-replace($Matches[0],'')
      }
      Pause
     }
    }
    else{$psISE.CurrentPowerShellTab.Files.Add($ErrorLog.InvocationInfo.ScriptName)|Out-Null}
   }
   if($ErrorLog.InvocationInfo.OffsetInLine-and$ErrorLog.InvocationInfo.ScriptLineNumber){Write-Host 'Line: ',$ErrorLog.InvocationInfo.ScriptLineNumber,$strTab,'Char: ',$ErrorLog.InvocationInfo.OffsetInLine,$strBreak}
   if($ErrorLog.InvocationInfo.Line){Write-Host 'InvocationInfo.Line:',$strBreak,$ErrorLog.InvocationInfo.Line,$strBreak}
  }
  default{Invoke-Item -Path $flinfErrorLog.FullName}
 }
}
end{
 $VarName='NextErrorlog';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='strPathErrorLogs';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='astrPath';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='strSplittedPath';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='i';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='strPathWorking';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='VarName';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
}