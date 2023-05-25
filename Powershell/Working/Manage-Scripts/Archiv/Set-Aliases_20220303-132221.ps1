[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath)
begin{
 [System.IO.FileInfo[]]$flinfScripts=$null
 [int]$i=0
 [int]$j=0
}
process{
 $flinfScripts=Get-ChildItem -Path $strFolderPath -Filter '*.ps1' -File -Force -Recurse|Sort-Object -Property LastWriteTimeUtc -Descending
 for($i=0;$i-lt$flinfScripts.Count;$i++){
  for($j=$i+1;$j-lt$flinfScripts.Count;$j++){
   $flinfScripts[$i].BaseName-match'^.[^_\d]*'|Out-Null
   if($flinfScripts[$j].BaseName-match$Matches[0]){
    $flinfScripts=$flinfScripts-ne$flinfScripts[$j]
   }
  }
 }
 for($i=0;$i-lt$flinfScripts.Count;$i++){
  $flinfScripts[$i].BaseName-match'^.[^_\d]*'|Out-Null
  if($Matches[0].Substring($Matches[0].Length-1,1-eq'_')){
   
  }
  Set-Alias -Name $Matches[0] -Value $flinfScripts[$i].FullName -Option AllScope,ReadOnly -Force -Scope Global
 }
}
end{
 $flinfScripts=$null
 $i=$null
 $j=$null
 Write-Errorlog -strFolderPath ($MyInvocation.MyCommand.Path-replace($MyInvocation.MyCommand.Name,'')) -strName $MyInvocation.MyCommand.Name
}