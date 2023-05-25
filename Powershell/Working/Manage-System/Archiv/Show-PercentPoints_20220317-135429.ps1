[CmdletBinding(SupportsShouldProcess)]
param(
 [parameter(Mandatory=$true)][int32]$intCount,
 [parameter(Mandatory=$true)][int32]$intMax,
 [parameter(Mandatory=$true)][int32]$intOld
)
begin{if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}}
process{
 [int32]$intPercent=$intCount/$intMax*100
 if($intPercent-gt$intOld){Write-Host '.' -NoNewline}
 return $intPercent
}
end{
 $VarName='intCount';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='intMax';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='intOld';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
 $VarName='VarName';if(Test-Path (-join('variable:',$VarName))){Remove-Variable -Name $VarName -Force}
}