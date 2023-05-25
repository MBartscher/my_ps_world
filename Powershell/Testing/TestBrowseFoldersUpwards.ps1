[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath)
begin{}
process{
 [System.IO.DirectoryInfo]$drinfFolder=Get-Item -Path $strFolderPath -Force
 while($drinfFolder.Parent.FullName-ne$null){
  Write-Verbose (-join('next folder:',"`t",$drinfFolder.FullName))
  [System.IO.FileInfo[]]$aflinfContainedScripts=Get-ChildItem -Path $drinfFolder.FullName -Filter '*.ps1' -Force -File|Where-Object{$_.FullName-notmatch'Archiv'}
  if($aflinfContainedScripts.Count-gt0){
   for([int]$i=0;$i-lt$aflinfContainedScripts.Count;$i++){
    Write-Verbose (-join('aflinfContainedScripts[',$i,']:',"`t",$aflinfContainedScripts[$i].BaseName))
    if($aflinfContainedScripts[$i].BaseName-eq'MySettings'){
     Write-Verbose (-join('found "MySettings.ps1":',"`t",$aflinfContainedScripts[$i].FullName))
     Invoke-Expression -Command $aflinfContainedScripts[$i].FullName
     Exit
    }
   }
  }
  Write-Verbose (-join('parent of current folder:',"`t",$drinfFolder.Parent.FullName))
  if($drinfFolder.Parent.FullName-ne$null){$drinfFolder=Get-Item -Path $drinfFolder.Parent.FullName -Force}
 }
 Write-Warning (-join('"MySettings.ps1" not found. Pls execute script "Set-MySettings"!'))
}
end{}