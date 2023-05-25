[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath,
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateSet('Descending','Ascending')][string]$strSortOrder
)
[System.IO.FileSystemInfo[]]$arrFiles=$null
Switch($strSortOrder){
 'Descending'{$arrFiles=(Get-ChildItem -Path $strFolderPath|Where-Object{$_.PSIsContainer-eq$false}|Sort-Object -Property LastWriteTimeUtc -Descending)}
 'Ascending'{$arrFiles=(Get-ChildItem -Path $strFolderPath|Where-Object{$_.PSIsContainer-eq$false}|Sort-Object -Property LastWriteTimeUtc)}
}
C:\DASI\Skripte\Powershell\Working\Manage-Files\Write-Errorlog_20220301-153049.ps1 -strFolderPath ($MyInvocation.MyCommand.Path-replace($MyInvocation.MyCommand.Name,'')) -strName $MyInvocation.MyCommand.Name
return $arrFiles