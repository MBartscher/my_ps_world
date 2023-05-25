[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath)
begin{
 [System.IO.FileInfo[]]$flinfScripts=$null
 [int]$i=0
 [int]$j=0
 if(-not($strAliasMask)){[string](New-Variable -Name strAliasMask -Value '^[^_\.]*' -Option AllScope,ReadOnly -Force -Scope Global)}
 if(-not($strLstWrtTmUTCMask)){[string](New-Variable -Name strLstWrtTmUTCMask -Value '_\d{8}-\d{5,6}$' -Option AllScope,ReadOnly -Force -Scope Global)}
 if($strFolderPath.Substring($strFolderPath.Length-1,1)-ne'\'){$strFolderPath+='\'}
 if(-not($strPathScripts)){[string](New-Variable -Name strPathScripts -Value $strFolderPath -Option AllScope,ReadOnly -Force -Scope Global)}
 else{Set-Variable -Name strPathScripts -Value $strFolderPath -Force}
 if(-not($strMySettingsScriptName)){[string](New-Variable -Name strMySettingsScriptName -Value 'MySettings' -Option AllScope,Constant -Force -Scope Global)}
 if(-not($strBreak)){[string](New-Variable -Name strBreak -Value "`n" -Option AllScope,ReadOnly -Force -Scope Global)}
 if(-not($strTab)){[string](New-Variable -Name strTab -Value "`t" -Option AllScope,ReadOnly -Force -Scope Global)}
}
process{
 [string]$strScriptMySettings=-join('#',(Get-Date -Format FileDateTimeUniversal),$strBreak)
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
  $strScriptMySettings+=-join('New-Alias -Name ',$Matches[0],' -Value ''',$flinfScripts[$i].FullName,''' -Option AllScope,ReadOnly -Force -Scope Global',$strBreak)
 }
 $strScriptMySettings+=-join('[string](New-Variable -Name strAliasMask -Value ''',$strAliasMask,''' -Option AllScope,ReadOnly -Force -Scope Global)',$strBreak)
 $strScriptMySettings+=-join('[string](New-Variable -Name strLstWrtTmUTCMask -Value ''',$strLstWrtTmUTCMask,''' -Option AllScope,ReadOnly -Force -Scope Global)',$strBreak)
 $strScriptMySettings+=-join('[string](New-Variable -Name strPathScripts -Value ''',$strPathScripts,''' -Option AllScope,ReadOnly -Force -Scope Global)',$strBreak)
 $strScriptMySettings+=-join('if(-not($strMySettingsScriptName)){[string](New-Variable -Name strMySettingsScriptName -Value ''',$strMySettingsScriptName,''' -Option AllScope,Constant -Force -Scope Global)}',$strBreak)
 $strScriptMySettings+=-join('[string](New-Variable -Name strBreak -Value "`n" -Option AllScope,ReadOnly -Force -Scope Global)',$strBreak)
 $strScriptMySettings+=-join('[string](New-Variable -Name strTab -Value "`t" -Option AllScope,ReadOnly -Force -Scope Global)')
 if(Test-Path -Path (-join($strPathScripts,$strMySettingsScriptName,'.ps1'))){Remove-Item -Path (-join($strPathScripts,$strMySettingsScriptName,'.ps1')) -Force}
 if($VerbosePreference){New-Item -Path $strPathScripts -Name (-join($strMySettingsScriptName,'.ps1')) -ItemType File -Value $strScriptMySettings -Force}
 else{New-Item -Path $strPathScripts -Name (-join($strMySettingsScriptName,'.ps1')) -ItemType File -Value $strScriptMySettings -Force|Out-Null}
}
end{
 $VarName='flinfScripts';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='i';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='j';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='strScriptMySettings';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='Matches';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='strFolderPath';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='VarName';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $flinfScripts
 Write-Errorlog
}