[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strParentPath,
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({$_-is[string]})][string]$strName
)
begin{if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}}
process{
 if(-not(Test-Path(($strParentPath,$strName)-join'\'))){
  if($VerbosePreference){New-Item -Path $strParentPath -Force -ItemType Directory -Name $strName}
  else{New-Item -Path $strParentPath -Force -ItemType Directory -Name $strName|Out-Null}
 }
}
end{}