[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({$_-is[string]})][string]$strFolderPath,
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({$_-is[string]})][string]$strName,
 [Parameter()][ValidateScript({$_-is[string]})][string]$strExclude,
 [Parameter()][ValidateScript({$_-is[string]})][string]$strInclude
)
if($Error.Count-gt0){
 Write-Warning (-join($Error.Count,' Errors occured in ',$strFolderPath,$strName))
 if($strFolderPath[$strFolderPath.Length-1]-ne'\'){$strFolderPath+='\'}
 C:\DASI\Skripte\Powershell\Working\Manage-Files\MakeSure-PathExists_20220228-153654.ps1 -strPath (-join($strFolderPath,'ErrorLogs'))
 while($Error.Count-gt0){
  if((($Error[0].ToString()-cnotmatch$strExclude)-and$strExclude)-or(($Error[0].ToString()-cmatch$strInclude)-and$strInclude)-or((-not$strExclude)-and(-not$strInclude))){
   [string]$strFileDateTimeUniversal=Get-Date -Format FileDateTimeUniversal
   -join('ToString():',"`n",$Error[0].ToString(),"`n`n") > (-join($strFolderPath,'ErrorLogs\',$strName,$strFileDateTimeUniversal,'.txt'))
   if($Error[0]-is[System.Management.Automation.ErrorRecord]){$Error[0] >> (-join($strFolderPath,'ErrorLogs\',$strName,$strFileDateTimeUniversal,'.txt'))}
   else{-join('Type: ',$Error[0].GetType(),"`n`n",$Error[0]) > (-join($strFolderPath,'ErrorLogs\',$strName,$strFileDateTimeUniversal,'.txt'))}
  }
  else{Write-Warning 'Error excluded'}
  $Error.Remove($Error[0])
 }
}
Invoke-Item -Path (-join($strFolderPath,'ErrorLogs'))