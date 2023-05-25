[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath)
begin{
 [System.IO.FileInfo[]]$flinfScripts=$null
 [int]$i=0
 [int]$j=0
}
process{
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
 }
}
end{
 $flinfScripts=$null
 $i=$null
 $j=$null
 Write-Errorlog -strFolderPath ($MyInvocation.MyCommand.Path-replace($MyInvocation.MyCommand.Name,''))
}