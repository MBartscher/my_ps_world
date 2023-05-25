param([parameter(Mandatory=$true)][int32]$iInput)

function Show-Progress{
 param(
  [parameter(Mandatory=$true)][int32]$iCount,
  [parameter(Mandatory=$true)][int32]$iMax,
  [parameter(Mandatory=$true)][int32]$iOld
 )
 [int32]$iPercent=$iCount/$iMax*100
 [string]$strOutput=-join("`r ",$iMax," ")
 for($i=0;$i-lt$iPercent;$i++){
  $strOutput+="."
 }
 return @($iPercent,$strOutput)
}

[array]$arrPercent=@()
for($i=0;$i-lt$iInput;$i++){
 $arrPercent=Show-Progress $i $iInput $arrPercent[0]
 Write-Host $arrPercent[1]# -NoNewline
}
#<#
[System.GC]::Collect()
#>