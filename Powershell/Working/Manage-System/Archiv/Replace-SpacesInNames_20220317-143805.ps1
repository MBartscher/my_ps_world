[CmdletBinding(SupportsShouldProcess)]
param(
 [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][ValidateScript({Test-Path -Path $_})][string]$strFolderPath,
 [Parameter(Mandatory=$true)][ValidateNotNull()][ValidateSet('_','-')][string]$strReplaceSign
)
begin{if(-not($strAliasMask)){C:\DASI\Skripte\Powershell\Working\MyAliases.ps1}}
process{
 [System.IO.DirectoryInfo]$drinfFolder=Get-Item -Path $strFolderPath
 if($drinfFolder.Exists){
  Get-ChildItem -Path $drinfFolder -Recurse -Force|Where-Object{$_.Name.Contains(' ')}|ForEach-Object{
   if(-not(Test-Path -Path $_.FullName.Replace(' ',$strReplaceSign))){
    Write-Verbose(-join('Replace " " with "',$strReplaceSign,'" in: ',$_.Name))
    Rename-Item -Path $_.PSPath -NewName $_.Name.Replace(' ',$strReplaceSign) -Force
   }
   else{
    [System.IO.FileInfo]$flinfAlreadyRenamed=Get-Item -Path $_.FullName.Replace(' ',$strReplaceSign)
    if($_.LastWriteTimeUtc-gt$flinfAlreadyRenamed.LastWriteTimeUtc){
     Remove-Item -Path $flinfAlreadyRenamed.FullName
     Write-Verbose(-join('Replace " " with "',$strReplaceSign,'" in: ',$_.Name))
     Rename-Item -Path $_.PSPath -NewName $_.Name.Replace(' ',$strReplaceSign) -Force
    }
    else{Remove-Item -Path $_.FullName}
   }
  }
  if($drinfFolder.Name.Contains(' ')){Rename-Item -Path $drinfFolder.PSPath -NewName $drinfFolder.Name.Replace(' ',$strReplaceSign) -Force}
 }
}
end{Write-Errorlog}