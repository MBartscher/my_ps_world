[CmdletBinding(SupportsShouldProcess)]
param()
begin{
 $MyInvocation.MyCommand.Name-match'^.[^_\d\.]*'|Out-Null
 if(-not(Test-Path -Path (-join('Alias:',$Matches[0])))){C:\DASI\Skripte\Powershell\Working\Manage-Files\Set-Aliases_20220303-150045.ps1 -strFolderPath ($MyInvocation.MyCommand.Path-replace($MyInvocation.MyCommand.Name,''))}
 [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")|Out-Null
 $fldlgSelectFile=New-Object System.Windows.Forms.OpenFileDialog
 $fldlgSelectFile.InitialDirectory='C:\DASI\Skripte\Powershell\InProgress'
 $fldlgSelectFile.Filter="ps1-Files (*.ps1)|*.ps1"
 $fldlgSelectFile.Multiselect=$false
 $fldlgSelectFile.ShowDialog()|Out-Null
 if($fldlgSelectFile.FileName-ne''-and$fldlgSelectFile.FileName-ne$null){[System.IO.FileSystemInfo]$flinfFile=Get-Item -Path $fldlgSelectFile.FileName}
 else{exit}
}
process{
 C:\DASI\Skripte\Powershell\InProgress\Manage-Files\MakeSure-PathExists.ps1 -strPath (($flinfFile.FullName-replace($flinfFile.Name,''))-replace('InProgress','Working'))
 Copy-Item -Path $flinfFile.FullName -Destination ($flinfFile.FullName-replace('InProgress','Working')-replace($flinfFile.Name,(-join($flinfFile.Name.Substring(0,$flinfFile.Name.IndexOf('.')),'_',($flinfFile.LastWriteTimeUtc-replace('[:-]','')-replace(' ','-')),$flinfFile.Extension)))) -Force
 [System.IO.FileSystemInfo[]]$aflinfSameScriptDiffVers=Get-ChildItem -Path ($flinfFile.FullName-replace($flinfFile.Name,'')) -File -Force|Where-Object{$_.BaseName-match$flinfFile.BaseName}
 Invoke-Item -Path ($flinfFile.FullName-replace($flinfFile.Name,'')-replace('InProgress','Working'))
}
end{
 $fldlgSelectFile=$null
 $flinfFile=$null
 Write-Errorlog -strFolderPath ($MyInvocation.MyCommand.Path-replace($MyInvocation.MyCommand.Name,''))
}