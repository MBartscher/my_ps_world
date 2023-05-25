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
return $arrFiles