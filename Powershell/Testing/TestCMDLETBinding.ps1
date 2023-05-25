[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory=$true)][string]$strInput)
Write-Verbose 'hallo welt!'
Write-Host ($strInput-replace(' ','%'))
[string]$strOutput=$strInput-replace('\d','#')
return $strOutput