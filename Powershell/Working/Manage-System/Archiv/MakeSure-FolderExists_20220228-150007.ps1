[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strParentPath,
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({$_-is[string]})][string]$strName
)
if(-not(Test-Path(($strParentPath,$strName)-join'\'))){New-Item -Path $strParentPath -Force -ItemType Directory -Name $strName}