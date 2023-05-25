[CmdletBinding(SupportsShouldProcess)]
param()
begin{if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}}
process{
 Write-Host 'hallo welt'
 Write-Verbose 'blahblahblahhhh...!'
 if($PSBoundParameters["Verbose"].IsPresent){
  Write-Host 'gelaber'
  Write-Verbose 'noch mehr blabla...'
 }
 if($VerbosePreference){Write-Host 'so?'}
}
end{}