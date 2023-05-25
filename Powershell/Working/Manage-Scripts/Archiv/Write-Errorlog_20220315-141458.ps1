[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter()][ValidateScript({$_-is[string]})][string]$strExclude,
 [Parameter()][ValidateScript({$_-is[string]})][string]$strInclude
)
begin{
 if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}
 [string]$strPathErrorLogs='C:\DASI\Skripte\Powershell\ErrorLogs\'
 if($strPathErrorLogs[$strPathErrorLogs.Length-1]-ne'\'){$strPathErrorLogs+='\'}
 MakeSure-PathExists -strPath $strPathErrorLogs
}
process{
 if($Error.Count-gt0){
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
   das ist ein fehler
   $Error.Remove($Error[0])
   #<#
   if($iCountOld-le$Error.Count){
    Write-Warning 'Infinite loop!' $MyInvocation.InvocationName
    Set-PSBreakpoint -Line 17 -Script $MyInvocation.InvocationName
    Write-Errorlog -Debug
   }#>
   $iCountOld=$Error.Count
  }
 }
 if($iExcluded-gt0){Write-Warning (-join($iExcluded,' Errors were excluded'))}
}
end{
 if((Get-Item -Path $strPathErrorLogs).GetFiles().Count-gt0){Invoke-Item -Path $strPathErrorLogs}
 else{Remove-Item -Path $strPathErrorLogs -Force}
 $strFileDateTimeUniversal=$null
 $iExcluded=$null
 $strExclude=$null
 $strInclude=$null
}