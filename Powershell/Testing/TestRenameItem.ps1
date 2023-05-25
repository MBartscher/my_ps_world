Write-Host 'Pfad eingeben: ' -NoNewline
[string]$strPath=Read-Host
Write-Host
[System.IO.FileSystemInfo[]]$aFiles=Get-ChildItem -Path $strPath -File -Include *.ps1 -Recurse -Force
for($i=0;$i-lt$aFiles.Count;$i++){
 <#
 Write-Host 'FullName:' $aFiles[$i].FullName
 Write-Host 'Name:' $aFiles[$i].Name
 Write-Host 'Extension:' $aFiles[$i].Extension
 Write-Host 'CreationTimeUtc:' $aFiles[$i].CreationTimeUtc
 Write-Host 'LastAccessTimeUtc:' $aFiles[$i].LastAccessTimeUtc
 Write-Host 'LastWriteTimeUtc:' $aFiles[$i].LastWriteTimeUtc
 Write-Host ($aFiles[$i].LastWriteTimeUtc.ToString()-Replace('[:-]','')-Replace(' ','-'))
 Write-Host
 #>
 Rename-Item -Path $aFiles[$i].FullName -NewName (-join($aFiles[$i].Name.Substring(0,$aFiles[$i].Name.IndexOf('.')),'_',($aFiles[$i].LastWriteTimeUtc-Replace('[:-]','')-Replace(' ','-')),$aFiles[$i].Extension)) -Force
}
#<#
$strPath=$null
$aFiles=$null
$i=$null
#>