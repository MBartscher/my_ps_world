[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string]$strPath)
begin{
 $MyInvocation.MyCommand.Name-match'^.[^_\d\.]*'|Out-Null
 if(-not(Test-Path -Path (-join('Alias:',$Matches[0])))){C:\DASI\Skripte\Powershell\Working\Manage-Files\Set-Aliases_20220303-150045.ps1 -strFolderPath ($MyInvocation.MyCommand.Path-replace($MyInvocation.MyCommand.Name,''))}     
 [string[]]$strPathParts=$strPath.Split('\')
 [string]$strPartialPath=$strPathParts[0]
}
process{
 for($i=1;$i-lt$strPathParts.Count;$i++){
  if($strPathParts[$i]){MakeSure-FolderExists -strParentPath $strPartialPath -strName $strPathParts[$i]}
  $strPartialPath=($strPartialPath,$strPathParts[$i])-join'\'
 }
}
end{
 $strPathParts=$null
 $strPartialPath=$null
 Write-Errorlog -strFolderPath ($MyInvocation.MyCommand.Path-replace($MyInvocation.MyCommand.Name,''))
}