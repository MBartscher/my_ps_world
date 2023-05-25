param(
 [Parameter(
  Mandatory = $true,
  HelpMessage = 'Enter the path of the folder where the files to examine are located in.'
 )]
 [string]$strFolderPath,
 [Parameter(
  Mandatory = $true,
  HelpMessage = 'Enter the max. fault time in seconds.'
 )]
 [int32]$iMaxFaultTime
)

Get-ChildItem $strFolderPath | ForEach-Object{
 if($_.Name.EndsWith(".csv")){
  C:\DASI\Skripte\Powershell\Working\AuswertungStoerungsCSV\AuswertungStoerungsCSV.ps1 $strFolderPath $_.Name $iMaxFaultTime
 }
}