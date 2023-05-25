﻿[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({$_-is[string]})][string]$strFolderPath,
 [Parameter()][ValidateScript({$_-is[string]})][string]$strExclude,
 [Parameter()][ValidateScript({$_-is[string]})][string]$strInclude
)
begin{
 $MyInvocation.MyCommand.Name-match'^.[^_\d\.]*'|Out-Null
 if(-not(Test-Path -Path (-join('Alias:',$Matches[0])))){C:\DASI\Skripte\Powershell\Working\Manage-Files\Set-Aliases_20220303-150045.ps1 -strFolderPath ($MyInvocation.MyCommand.Path-replace($MyInvocation.MyCommand.Name,''))}
}
process{
 if($Error.Count-gt0){
  Write-Warning (-join($Error.Count,' Errors occured'))
  if($strFolderPath[$strFolderPath.Length-1]-ne'\'){$strFolderPath+='\'}
  C:\DASI\Skripte\Powershell\Working\Manage-Files\MakeSure-PathExists_20220228-153654.ps1 -strPath (-join($strFolderPath,'ErrorLogs'))
  [int]$iExcluded=$null
  while($Error.Count-gt0){
   if((($Error[0].ToString()-cnotmatch$strExclude)-and$strExclude)-or(($Error[0].ToString()-cmatch$strInclude)-and$strInclude)-or((-not$strExclude)-and(-not$strInclude))){
    [string]$strFileDateTimeUniversal=Get-Date -Format FileDateTimeUniversal
    -join('ToString():',"`n",$Error[0].ToString(),"`n`n") > (-join($strFolderPath,'ErrorLogs\',$strFileDateTimeUniversal,'.txt'))
    if($Error[0]-is[System.Management.Automation.ErrorRecord]){$Error[0] >> (-join($strFolderPath,'ErrorLogs\',$strFileDateTimeUniversal,'.txt'))}
    else{-join('Type: ',$Error[0].GetType(),"`n`n",$Error[0]) > (-join($strFolderPath,'ErrorLogs\',$strFileDateTimeUniversal,'.txt'))}
   }
   else{$iExcluded++}
   $Error.Remove($Error[0])
  }
 }
 if($iExcluded-gt0){Write-Warning (-join($iExcluded,' errors were excluded'))}
 #[int]$iErrorLogs=(Get-Item -Path (-join($strFolderPath,'ErrorLogs'))).GetFiles().Count
 if((Get-Item -Path (-join($strFolderPath,'ErrorLogs'))).GetFiles().Count-gt0){Invoke-Item -Path (-join($strFolderPath,'ErrorLogs'))}
}
end{
 $strFileDateTimeUniversal=$null
 $iExcluded=$null
}