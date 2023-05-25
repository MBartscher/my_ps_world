[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath,
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({[datetime]::TryParse($_,([ref]$parsed=Get-Date))})][DateTime]$dtOldestDate
)
begin{if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}}
process{
 Get-FilesFrmFolderSrtdByLstWrTmUTC -strFolderPath $strFolderPath -Descending |ForEach-Object{
 if($_.LastWriteTimeUtc-lt$dtOldestDate){
   Write-Verbose (-join('"',$_,'" wird geloescht!'))
   $_|Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
  }
 }
}
end{Write-Errorlog}