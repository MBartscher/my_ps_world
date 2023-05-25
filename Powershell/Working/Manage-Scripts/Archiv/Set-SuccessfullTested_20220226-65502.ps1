[CmdletBinding(SupportsShouldProcess)]
param()
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")|Out-Null
$fldlgSelectFile=New-Object System.Windows.Forms.OpenFileDialog
$fldlgSelectFile.InitialDirectory='C:\DASI\Skripte\Powershell\InProgress'
$fldlgSelectFile.Filter="ps1-Files (*.ps1)|*.ps1"
$fldlgSelectFile.Multiselect=$false
$fldlgSelectFile.ShowDialog()|Out-Null
if($fldlgSelectFile.FileName-ne''-and$fldlgSelectFile.FileName-ne$null){[System.IO.FileSystemInfo]$flinfFile=Get-Item -Path $fldlgSelectFile.FileName}
else{exit}
Copy-Item -Path $flinfFile.FullName -Destination ($flinfFile.FullName-replace('InProgress','Working')-replace($flinfFile.Name,(-join($flinfFile.Name.Substring(0,$flinfFile.Name.IndexOf('.')),'_',($flinfFile.LastWriteTimeUtc-replace('[:-]','')-replace(' ','-')),$flinfFile.Extension)))) -Force
Invoke-Item -Path ($flinfFile.FullName-replace($flinfFile.Name,'')-replace('InProgress','Working'))
$fldlgSelectFile=$null
$flinfFile=$null