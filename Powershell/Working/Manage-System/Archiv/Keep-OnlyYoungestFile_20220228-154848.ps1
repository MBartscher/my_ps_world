﻿[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath)
Write-Host(-join('Aus: "',$strFolderPath,'" nur juengste behalten.'))
[System.IO.FilesystemInfo[]]$arrFiles=C:\DASI\Skripte\Powershell\Working\Manage-Files\Get-FilesFrmFolderSrtdByLstWrTmUTC_20220226-64954.ps1 -strFolderPath $strFolderPath -strSortOrder Descending
if($arrFiles.count-gt1){C:\DASI\Skripte\Powershell\Working\Manage-Files\Delete-FilesOlderThan_20220228-153405.ps1 -strFolderPath $strFolderPath -dtOldestDate $arrFiles[0].LastWriteTimeUtc}
else{Write-Host 'Nur eine Datei vorhanden.'}
Write-Host (-join ($strFolderPath,': Fertig!'))