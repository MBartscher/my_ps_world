param(
 [Parameter(
  Mandatory = $true,
  HelpMessage = 'Enter the path of the folder where the file to examine is located in.'
 )]
 [string]$strFolderPath,
 [Parameter(
  Mandatory = $true,
  HelpMessage = 'Enter the name of the file to examine.'
 )]
 [string]$strFileName,
 [Parameter(
  Mandatory = $true,
  HelpMessage = 'Enter the max. fault time in seconds.'
 )]
 [int32]$iMaxFaultTime
)

class Result {
 [string]$BMK
 [string]$Stoerort
 [string]$Meldetext
 [int32]$Haeufigkeit;
}

[string]$strFilePath = -join ($strfolderpath,'\',$strfilename)

[object[]]$CSV = $strFilePath | Import-Csv -Delimiter ';' | Sort-Object -Property BMK,Uhrzeit

$tispMaxFaultTime = New-TimeSpan -Seconds $iMaxFaultTime

[timespan[]]$tispTimeDiff = 0
[int32]$iBMKCount = 0
[int32[]]$iFaultCount = 0
$objResults = @([Result]::new(),[Result]::new())
[int32]$iResultCount = 0

for ([int32]$i = 1; $i -lt ($CSV.Count); $i++){
 $tispTimeDiff += 0
 if ($CSV[$i].BMK -eq ($CSV[$i-1].BMK)){
  if ($CSV[$i].Zustand.Equals('-') -and $CSV[$i-1].Zustand.Equals('+') -and !($CSV[$i].Art -eq 'Sichtkontrollen')){
   $tispTimeDiff[$i] = [timespan]$CSV[$i].Uhrzeit - [timespan]$CSV[$i-1].Uhrzeit
  }
  if (($tispTimeDiff[$i] -gt '0:00:00') -and ($tispTimeDiff[$i] -le $tispMaxFaultTime)){
   $iFaultCount[$iBMKCount] ++
  }
 }
 else{
  if ($iFaultCount[$iBMKCount] -gt 0){
   if ($objResults.Count-1 -lt $iBMKCount){
    $objResults += [Result]::new()
    $iResultCount ++
   }
   $objResults[$iResultCount].BMK = $CSV[$i-1].BMK
   $objResults[$iResultCount].Stoerort = $CSV[$i-1].Störort
   $objResults[$iResultCount].Meldetext = $CSV[$i-1].Meldetext
   $objResults[$iResultCount].Haeufigkeit = $iFaultCount[$iBMKCount]
  }
  $iBMKCount ++
  $iFaultCount += 0
 }
}

$objResults = $objResults | Sort-Object -Property Haeufigkeit -Descending
$strFilePath = $strFilePath.Replace(".csv",("_",$iMaxFaultTime,"s.html") -join "")
$objResults | ConvertTo-Html -Title $strFileName.Replace(".csv",("_",$iMaxFaultTime,"s.html") -join "") -As Table > $strFilePath
Invoke-Item $strFilePath