if(!$strPath){New-Variable -Name strPath -Value 'C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\DASI\Skripte\Powershell\Working'}
if(!$strPath.GetType().Name-eq'String'){$strPath=[string]$strPath}
if(!$strPath.EndsWith('\')){$strPath+='\'}
if(!$strScriptName){New-Variable -Name strScriptName -Value 'MySettings.ps1'}
if(!$flinfScript){New-Variable -Name flinfScript -Value $null}
Set-Variable -Name flinfScript -Value (Get-Item -Path (-join($strPath,$strScriptName)))
Write-Host $flinfScript.FullName
Invoke-Expression -Command (-join('& ''',$flinfScript.FullName,''''))
if($strPathScripts){Write-Host $strPathScripts}
set-successfulltested

Invoke-Expression -Command (-join('& ''',$strPath,'Manage-Scripts\Set-SuccessfullTested_20220513-132044.ps1'''))