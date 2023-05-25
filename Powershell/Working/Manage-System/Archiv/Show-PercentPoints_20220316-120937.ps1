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
 Write-Verbose 'test'
 return $intPercent
}
end{
 $intCount=$null
 $intMax=$null
 $intOld=$null
}