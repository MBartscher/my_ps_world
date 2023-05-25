[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter()][switch]$NextErrorlog
)
begin{
 if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MySettings.ps1}
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
   if(Test-Path -Path $strPathErrorLogs){if((Get-ChildItem -Path $strPathErrorLogs).Count-eq0){Remove-Item -Path $strPathErrorLogs}}
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
   Write-Warning (-join($strBreak,$ErrorLog.ToString(),$strBreak))
   if($ErrorLog.ErrorCategory_Activity){Write-Host 'ErrorCategory_Activity:',$strBreak,$strTab,$ErrorLog.ErrorCategory_Activity,$strBreak}
   if($ErrorLog.ErrorCategory_Message){Write-Host 'ErrorCategory_Message:',$strBreak,$strTab,$ErrorLog.ErrorCategory_Message,$strBreak}
   if($ErrorLog.InvocationInfo.ScriptName){
    Write-Host 'InvocationInfo.ScriptName:',$strBreak,$strTab,$ErrorLog.InvocationInfo.ScriptName,$strBreak
    if($ErrorLog.InvocationInfo.ScriptName-match'\\Working\\'){
     $ErrorLog.InvocationInfo.ScriptName-match'_\d{8}-\d{5,6}'|Out-Null
     $psISE.CurrentPowerShellTab.Files.Add($ErrorLog.InvocationInfo.ScriptName-replace('Working','Inprogress')-replace($Matches[0],''))|Out-Null
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
   if($ErrorLog.InvocationInfo.Line){Write-Host 'InvocationInfo.Line:',$strBreak,$strTab,$ErrorLog.InvocationInfo.Line,$strBreak}
  }
  default{Invoke-Item -Path $flinfErrorLog.FullName}
 }
}
end{
 $VarName='NextErrorlog';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='strPathErrorLogs';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='VarName';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
}