[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath,
 [Parameter()][switch]$updateHelp
)
begin{
 if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}
 function Show-Percent{
  param(
   [parameter(Mandatory=$true)][int32]$intCount,
   [parameter(Mandatory=$true)][int32]$intMax,
   [parameter(Mandatory=$true)][int32]$intOld
  )
  [int32]$intPercent=0
  $intPercent=$intCount/$intMax*100
  if($intPercent-gt$intOld){Write-Host $intPercent '%'}
  $intCount=$null
  $intMax=$null
  $intOld=$null
  return $intPercent
 }
}
process{
 if($updateHelp.IsPresent){
  Write-Host '#=> update Help'
  Update-Help -Force
 }
 $Aliases=@()
 [int32]$intRem=0
 $HelpList=Get-Help *
 for($i=0;$i-lt$HelpList.Count;$i++){
  $intRem=Show-Percent -intCount $i -intMax $HelpList.Count -intOld $intRem
  if($HelpList[$i].Category-eq"Alias"){$Aliases+=$HelpList[$i]}
  else{Create-HelpTxtFile -strFolderPath $strFolderPath -strHelpTopic $HelpList[$i].Name}
 }
 if($strFolderPath[$strFolderPath.Length-1]-ne'\'){$strFolderPath+='\'}
 $Aliases > (-join($strFolderPath,'Aliases.txt'))
 cmd.exe /? > (-join($strFolderPath,'cmd.exe.txt'))
}
end{
 $Aliases=$null
 $intRem=$null
 $HelpList=$null
 $i=$null
 [System.GC]::Collect()
 Write-Errorlog
}