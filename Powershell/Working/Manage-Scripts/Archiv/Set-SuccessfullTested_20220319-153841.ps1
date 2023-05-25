[CmdletBinding(SupportsShouldProcess)]
param()
begin{
 if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MySettings.ps1}
 [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")|Out-Null
 $fldlgSelectFile=New-Object System.Windows.Forms.OpenFileDialog
 $fldlgSelectFile.InitialDirectory='C:\DASI\Skripte\Powershell\InProgress'
 $fldlgSelectFile.Filter="ps1-Files (*.ps1)|*.ps1"
 $fldlgSelectFile.Multiselect=$false
 $fldlgSelectFile.ShowDialog()|Out-Null
 if($fldlgSelectFile.FileName){[System.IO.FileSystemInfo]$flinfFile=Get-Item -Path $fldlgSelectFile.FileName}
 else{exit}
}
process{
 MakeSure-PathExists -strPath (($flinfFile.FullName-replace($flinfFile.Name,''))-replace('InProgress','Working'))
 Copy-Item -Path $flinfFile.FullName -Destination ($flinfFile.FullName-replace('InProgress','Working')-replace($flinfFile.Name,(-join($flinfFile.Name.Substring(0,$flinfFile.Name.IndexOf('.')),'_',($flinfFile.LastWriteTimeUtc-replace('[:-]','')-replace(' ','-')),$flinfFile.Extension)))) -Force
 [System.IO.FileSystemInfo[]]$aflinfSameScriptDiffVers=Get-ChildItem -Path ($flinfFile.FullName-replace('InProgress','Working')-replace($flinfFile.Name,'')) -File -Force|Where-Object{$_.BaseName-match$flinfFile.BaseName}|Sort-Object -Descending -Property LastWriteTimeUtc
 if($aflinfSameScriptDiffVers.Count-gt1){
  MakeSure-PathExists -strPath (-join((($flinfFile.FullName-replace($flinfFile.Name,''))-replace('InProgress','Working')),'Archiv'))
  for($i=1;$i-lt$aflinfSameScriptDiffVers.Count;$i++){Move-Item -Path $aflinfSameScriptDiffVers[$i].FullName -Destination ($aflinfSameScriptDiffVers[$i].FullName-replace($aflinfSameScriptDiffVers[$i].Name,'Archiv\')) -Force}
 }
 Invoke-Item -Path ($flinfFile.FullName-replace($flinfFile.Name,'')-replace('InProgress','Working'))
 [System.IO.FileInfo]$flinfSetAliases=Get-ChildItem -Path (-join($strPathScripts,'\Manage-Scripts')) -Filter '*Set-MySettings*' -Force -File
 Invoke-Expression -Command (-join($flinfSetAliases.FullName,' -strFolderPath ',$strPathScripts))
}
end{
 $VarName='fldlgSelectFile';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='flinfFile';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='aflinfSameScriptDiffVers';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='i';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='flinfSetAliases';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='VarName';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 Write-Errorlog
}