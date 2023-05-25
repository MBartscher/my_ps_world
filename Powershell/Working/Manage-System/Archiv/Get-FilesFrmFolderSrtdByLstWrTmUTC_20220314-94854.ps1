[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath,
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateSet('Descending','Ascending')][string]$strSortOrder
)
begin{
 if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}
 [System.IO.FileSystemInfo[]]$arrFiles=$null
}
process{
 Switch($strSortOrder){
  'Descending'{$arrFiles=(Get-ChildItem -Path $strFolderPath|Where-Object{$_.PSIsContainer-eq$false}|Sort-Object -Property LastWriteTimeUtc -Descending)}
  'Ascending'{$arrFiles=(Get-ChildItem -Path $strFolderPath|Where-Object{$_.PSIsContainer-eq$false}|Sort-Object -Property LastWriteTimeUtc)}
 }
 return $arrFiles
}
end{Write-Errorlog}