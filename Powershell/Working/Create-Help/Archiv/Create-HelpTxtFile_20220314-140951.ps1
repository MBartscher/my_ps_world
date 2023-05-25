[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath,
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({$_-is[string]})][string]$strHelpTopic
)
begin{if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}}
process{
 [string]$strFileName=Replace-SignWithWord -strInput $strHelpTopic
 if($strFolderPath[$strFolderPath.Length-1]-ne'\'){$strFolderPath+='\'}
 if(Get-Help $strHelpTopic -Detailed){Get-Help $strHelpTopic -Detailed > (-join($strFolderPath,$strFileName,'.txt'))}
}
end{
 $strFileName=$null
 Write-Errorlog
}