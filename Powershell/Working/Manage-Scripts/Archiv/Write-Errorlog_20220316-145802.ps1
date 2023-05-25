[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter()][ValidateScript({$_-is[string]})][string]$strExclude,
 [Parameter()][ValidateScript({$_-is[string]})][string]$strInclude
)
begin{
 if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}
 [string]$strPathErrorLogs='C:\DASI\Unique\Powershell\ErrorLogs\'
 if($strPathErrorLogs[$strPathErrorLogs.Length-1]-ne'\'){$strPathErrorLogs+='\'}
 MakeSure-PathExists -strPath $strPathErrorLogs
 $strExclude+='The term ''(.|`n)*\\Write-Errorlog_\d{8}-\d{5,6}\.ps1'' is not recognized as the name of a cmdlet, function, script file, or operable program.'
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
   $Error.Remove($Error[0])
   if($iCountOld-le$Error.Count){
    Write-Warning (-join('Infinite loop!',$MyInvocation.InvocationName))
    Set-PSBreakpoint -Line 17 -Script $MyInvocation.InvocationName
    if($Error.Count-gt0-and$Error[0].CategoryInfo.Activity-match'Set-PSBreakpoint'-and$Error[0].ToString()-match'Cannot find path .* because it does not exist\.'){
     pause
    }
    Write-Errorlog -Debug
   }
   $iCountOld=$Error.Count
  }
 }
 if($iExcluded-gt0){Write-Warning (-join($iExcluded,' Errors were excluded'))}
}
end{
 <#
 if((Get-Item -Path $strPathErrorLogs).GetFiles().Count-gt0){Invoke-Item -Path $strPathErrorLogs}
 else
 #>
 #<#
 if((Get-Item -Path $strPathErrorLogs).GetFiles().Count-eq0)
 #>
 {Remove-Item -Path $strPathErrorLogs -Force}
 $strFileDateTimeUniversal=$null
 $iExcluded=$null
 $strExclude=$null
 $strInclude=$null
}