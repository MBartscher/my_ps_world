﻿
[string[]]$strArray=@('q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m')
<#
for($i=0;$i-lt$strArray.Count;$i++){
 for($k=1;$k-lt$strArray.Count-$i;$k++){
  if($strArray[$k-1]-gt$strArray[$k]){
   [string]$strRem=$strArray[$k-1]
   $strArray[$k-1]=$strArray[$k]
   $strArray[$k]=$strRem
  }
 }
}
#>
[bool]$bSwapped=$false
[string]$strRem=''
<#
do{
 $bSwapped=$false
 for($i=0;$i-lt$strArray.Count-1;$i++){
  if($strArray[$i]-gt$strArray[$i+1]){
   $strRem=$strArray[$i]
   $strArray[$i]=$strArray[$i+1]
   $strArray[$i+1]=$strRem
   $bSwapped=$true
  }
 }
}while($bSwapped)
#>
for($i=1;$i-lt$strArray.Count;$i++){
 $bSwapped=$false
 for($k=0;$k-lt$strArray.Count-$i;$k++){
  if($strArray[$k]-gt$strArray[$k+1]){
   $strRem=$strArray[$k]
   $strArray[$k]=$strArray[$k+1]
   $strArray[$k+1]=$strRem
   $bSwapped=$true
  }
 }
 if(!$bSwapped){break}
}

Write-Host $strArray