[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath,
 [Parameter()][switch]$Descending
)
begin{
 if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}
 [System.IO.FileSystemInfo[]]$arrFiles=$null
}
process{
 if($Descending.IsPresent){$arrFiles=(Get-ChildItem -Path $strFolderPath|Where-Object{$_.PSIsContainer-eq$false}|Sort-Object -Property LastWriteTimeUtc -Descending)}
 else{$arrFiles=(Get-ChildItem -Path $strFolderPath|Where-Object{$_.PSIsContainer-eq$false}|Sort-Object -Property LastWriteTimeUtc)}
 return $arrFiles
}
end{Write-Errorlog}