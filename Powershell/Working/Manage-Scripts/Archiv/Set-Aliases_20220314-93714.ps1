[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath)
begin{
 [System.IO.FileInfo[]]$flinfScripts=$null
 [int]$i=0
 [int]$j=0
 if(-not($strAliasMask)){New-Variable -Name strAliasMask -Value '^.[^_\.]*' -Option AllScope,ReadOnly -Force -Scope Global}
}
process{
 [string]$strScriptAliases=-join('#',(Get-Date -Format FileDateTimeUniversal),"`n")
 $flinfScripts=Get-ChildItem -Path $strFolderPath -Filter '*.ps1' -File -Force -Recurse|Where-Object{-not($_.FullName-match'\\Archiv\\')}|Sort-Object -Property BaseName,LastWriteTimeUtc -Descending
 for($i=0;$i-lt$flinfScripts.Count;$i++){
  $flinfScripts[$i].BaseName-match$strAliasMask|Out-Null
  $j=$i+1
  while($j-lt$flinfScripts.Count){
   if($flinfScripts[$j].BaseName-match$Matches[0]){$flinfScripts=$flinfScripts-ne$flinfScripts[$j]}
   else{$j++}
  }
 }
 for($i=0;$i-lt$flinfScripts.Count;$i++){
  $flinfScripts[$i].BaseName-match$strAliasMask|Out-Null
  New-Alias -Name $Matches[0] -Value $flinfScripts[$i].FullName -Option AllScope,ReadOnly -Force -Scope Global
  $strScriptAliases+=-join('New-Alias -Name ',$Matches[0],' -Value ',$flinfScripts[$i].FullName,' -Option AllScope,ReadOnly -Force -Scope Global',"`n")
 }
 $strScriptAliases+=-join("New-Variable -Name strAliasMask -Value '^.[^_\.]*' -Option AllScope,ReadOnly -Force -Scope Global")
 if(Test-Path -Path C:\DASI\Skripte\Powershell\Working\MyAliases.ps1){Remove-Item -Path C:\DASI\Skripte\Powershell\Working\MyAliases.ps1 -Force}
 New-Item -Path C:\DASI\Skripte\Powershell\Working\ -Name MyAliases.ps1 -ItemType File -Value $strScriptAliases -Force
}
end{
 $flinfScripts=$null
 $i=$null
 $j=$null
 $strScriptAliases=$null
}




