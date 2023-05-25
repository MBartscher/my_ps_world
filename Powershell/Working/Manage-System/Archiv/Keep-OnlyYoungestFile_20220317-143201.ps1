[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath)
begin{if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}}
process{
 Write-Verbose (-join('Aus: "',$strFolderPath,'" nur juengste behalten.'))
 [System.IO.FilesystemInfo[]]$arrFiles=Get-FilesFrmFolderSrtdByLstWrTmUTC -strFolderPath $strFolderPath -Descending
 if($arrFiles.count-gt1){Delete-FilesOlderThan -strFolderPath $strFolderPath -dtOldestDate $arrFiles[0].LastWriteTimeUtc}
 else{Write-Verbose 'Nur eine Datei vorhanden.'}
 Write-Verbose (-join ($strFolderPath,': Fertig!'))
}
end{Write-Errorlog}