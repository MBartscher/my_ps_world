[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter()][ValidateScript({$_-is[string]})][string]$strExclude,
 [Parameter()][ValidateScript({$_-is[string]})][string]$strInclude
)
begin{
 if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}
}
process{
 if($Error.Count-gt0){
  Write-Warning (-join($Error.Count,' Errors occured'))
  MakeSure-PathExists -strPath C:\DASI\Skripte\Powershell\ErrorLogs
  [int]$iExcluded=$null
  while($Error.Count-gt0){
   if(((($Error[0].ToString()-cnotmatch$strExclude)-and$strExclude)-or(($Error[0].ToString()-cmatch$strInclude)-and$strInclude)-or((-not$strExclude)-and(-not$strInclude)))-and(-not($Error[0]-is[System.Management.Automation.TerminateException]))){
    [string]$strFileDateTimeUniversal=Get-Date -Format FileDateTimeUniversal
    -join('ToString():',"`n",$Error[0].ToString(),"`n`n") > (-join('C:\DASI\Skripte\Powershell\ErrorLogs\',$strFileDateTimeUniversal,'.txt'))
    if($Error[0]-is[System.Management.Automation.ErrorRecord]){$Error[0] >> (-join('C:\DASI\Skripte\Powershell\ErrorLogs\',$strFileDateTimeUniversal,'.txt'))}
    else{-join('Type: ',$Error[0].GetType(),"`n`n",$Error[0]) > (-join('C:\DASI\Skripte\Powershell\ErrorLogs\',$strFileDateTimeUniversal,'.txt'))}
   }
   else{$iExcluded++}
   $Error.Remove($Error[0])
  }
 }
 if($iExcluded-gt0){Write-Warning (-join($iExcluded,' Errors were excluded'))}
 if(Test-Path -Path C:\DASI\Skripte\Powershell\ErrorLogs){if((Get-Item -Path C:\DASI\Skripte\Powershell\ErrorLogs).GetFiles().Count-gt0){Invoke-Item -Path C:\DASI\Skripte\Powershell\ErrorLogs}
 }
}
end{
 $strFileDateTimeUniversal=$null
 $iExcluded=$null
}