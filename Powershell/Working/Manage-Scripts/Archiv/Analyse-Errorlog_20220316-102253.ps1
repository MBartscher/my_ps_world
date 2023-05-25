[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter()][switch]$NextErrorlog
)
begin{
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
 if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}
 [string]$strPathErrorLogs='C:\DASI\Skripte\Powershell\ErrorLogs'
 if($strPathErrorLogs[$strPathErrorLogs.Length-1]-ne'\'){$strPathErrorLogs+='\'}
 Test-ErrorLogsFolderExists -strPathErrorLogs $strPathErrorLogs
}
process{
 [System.IO.FileInfo]$flinfErrorLog=(Get-FilesFrmFolderSrtdByLstWrTmUTC -strFolderPath $strPathErrorLogs -Descending)[0]
 if($NextErrorlog.IsPresent){
  Remove-Item -Path ($flinfErrorLog.FullName)
  Test-ErrorLogFilesExist -strPathErrorLogs $strPathErrorLogs
  $flinfErrorLog=(Get-FilesFrmFolderSrtdByLstWrTmUTC -strFolderPath $strPathErrorLogs -Descending)[0]
 }
 switch($flinfErrorLog.Extension){
  '.xml'{
   $ErrorLog=Import-Clixml -Path $flinfErrorLog.FullName
   if($Error.Count-gt0-and$Error[0].ToString()-match'Data at the root level is invalid.'){
    Write-Warning (-join($Error[0].ToString(),$strBreak,'Filename: ',$strBreak,$strTab,$flinfErrorLog.FullName))
    pause
   }
   Write-Warning (-join($strBreak,$ErrorLog.ToString(),$strBreak))
   if($ErrorLog.ErrorCategory_Activity){Write-Host 'ErrorCategory_Activity:',$strBreak,$strTab,$ErrorLog.ErrorCategory_Activity,$strBreak}
   if($ErrorLog.ErrorCategory_Message){Write-Host 'ErrorCategory_Message:',$strBreak,$strTab,$ErrorLog.ErrorCategory_Message,$strBreak}
   if($ErrorLog.InvocationInfo.ScriptName){
    Write-Host 'InvocationInfo.ScriptName:',$strBreak,$strTab,$ErrorLog.InvocationInfo.ScriptName,$strBreak
    $psISE.CurrentPowerShellTab.Files.Add($ErrorLog.InvocationInfo.ScriptName)
   }
   if($ErrorLog.InvocationInfo.OffsetInLine-and$ErrorLog.InvocationInfo.ScriptLineNumber){Write-Host 'Line: ',$ErrorLog.InvocationInfo.ScriptLineNumber,$strTab,'Char: ',$ErrorLog.InvocationInfo.OffsetInLine,$strBreak}
   if($ErrorLog.InvocationInfo.Line){Write-Host 'InvocationInfo.Line:',$strBreak,$strTab,$ErrorLog.InvocationInfo.Line,$strBreak}
   if($ErrorLog.ErrorDetails_ScriptStackTrace){Write-Host 'ErrorDetails_ScriptStackTrace:',($strBreak*2),$ErrorLog.ErrorDetails_ScriptStackTrace,$strBreak}
  }
  default{Invoke-Item -Path $flinfErrorLog.FullName}
 }
}
end{}