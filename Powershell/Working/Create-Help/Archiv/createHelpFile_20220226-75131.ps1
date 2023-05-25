[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath,
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({$_-is[string]})][string]$strHelpTopic
)
[string]$strFileName=C:\DASI\Skripte\Powershell\Working\manageFiles\Replace-SignWithWord_20220225-132417.ps1 -strInput $strHelpTopic
if($strFolderPath[$strFolderPath.Length-1]-ne'\'){$strFolderPath+='\'}
if((Get-Help $strHelpTopic -Detailed)-ne''){Get-Help $strHelpTopic -Detailed > (-join($strFolderPath,$strFileName,'.txt'))}
$strFileName=$null