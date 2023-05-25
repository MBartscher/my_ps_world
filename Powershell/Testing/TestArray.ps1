$arrDummy=@('abc-qwerty','abc-uioop','abc-asdf','abc-ghjk','abc-zxcv','abc-vbnm','def-qwerty','def-uioop','def-asdf','def-ghjk','ghi-zxcv','ghi-vbnm','xyz-vbnm')

[string[][]]$arrVerbs=@(@())
[string[][]]$arrNouns=@(@())

for($i=0;$i-lt$arrDummy.Count;$i++){
 $splitted=$arrDummy[$i]-split'-'
 <#
 Write-Host $splitted[0]'/'$splitted[1]
 #>
 [bool]$bAllreadyIncluded=$false
 for($j=0;$j-lt$arrVerbs.Count;$j++){
  $bAllreadyIncluded=$arrVerbs[$j][0]-eq$splitted[0]
  if($bAllreadyIncluded){break}
 }
 if(!$bAllreadyIncluded){
  $arrVerbs+=@($splitted[0])
  $arrVerbs[$j]+=$arrDummy[$i]
 }
 else{
  $arrVerbs[$j]+=$arrDummy[$i]
 }
 $bAllreadyIncluded=$false
 for($j=0;$j-lt$arrNouns.Count;$j++){
  $bAllreadyIncluded=$arrNouns[$j][0]-eq$splitted[1]
  if($bAllreadyIncluded){break}
 }
 if(!$bAllreadyIncluded){
  $arrNouns+=@($splitted[1])
  $arrNouns[$j]+=$arrDummy[$i]
 }
 else{
  <#
  Write-Host $j $splitted[1]
  #>
  #for($j=0;$j-lt$arrNouns.Count;$j++){
   #if($splitted[1]-eq$arrNouns[$j][0]){
    $arrNouns[$j]+=$arrDummy[$i]
    #break
   #}
  #}
 }
 Write-Host ($i/$arrDummy.Count*100) '%'
}
#<#
Write-Host '100 %'
Write-Host
for($i=0;$i-lt$arrVerbs.Count;$i++){
 Write-Host $i $arrVerbs[$i]
}
Write-Host
for($i=0;$i-lt$arrNouns.Count;$i++){
 Write-Host $i $arrNouns[$i]
}
#>
Write-Host
for($i=0;$i-lt$arrVerbs.Count;$i++){
 [string[]]$arrLine=$arrVerbs[$i][1..($arrVerbs[$i].Count-1)]
 Write-Host $arrLine
 Write-Host
}