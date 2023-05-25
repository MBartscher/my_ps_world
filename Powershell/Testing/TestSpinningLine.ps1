[int32]$iInput=1
[string]$str1='-'
[string]$str2='/'
[string]$str3='|'
[string]$str4='\'
for($i=0;$i-lt$iInput;$i++){
 switch($i%4){
  0{Write-Host "`r -" -NoNewline}
  1{Write-Host "`r /" -NoNewline}
  2{Write-Host "`r |" -NoNewline}
  3{Write-Host "`r \" -NoNewline}
 }
 $iInput++
}