[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath,
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({[datetime]::TryParse($_,([ref]$parsed=Get-Date))})][DateTime]$dtOldestDate
)
C:\DASI\Skripte\Powershell\Working\Manage-Files\Get-FilesFrmFolderSrtdByLstWrTmUTC_20220226-64954.ps1 -strFolderPath $strFolderPath -strSortOrder Descending |ForEach-Object{
 if($_.LastWriteTimeUtc-lt$dtOldestDate){
  Write-Host(-join('"',$_,'" wird geloescht!'))
  $_|Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
 }
}
C:\DASI\Skripte\Powershell\Working\Manage-Files\Write-Errorlog_20220301-153049.ps1 -strFolderPath ($MyInvocation.MyCommand.Path-replace($MyInvocation.MyCommand.Name,'')) -strName $MyInvocation.MyCommand.Name