



$UsbDrive=Get-PSDrive H

[int]$i=0
$BackupOnUsb=Get-ChildItem -Path H:\PromaticBackup -Exclude 'Unique'|Sort-Object -Property CreationTime
$today=Get-Date
$today=$today.Date
$SizeDasiWithoutUnique=Get-Item -Path C:\DASI|Get-ChildItem -Recurse|Where-Object{!($_.FullName-like'*Unique*')}|Measure-Object -Property Length -Sum
$SizeDasiUnique=Get-Item -Path C:\DASI\Unique|Get-ChildItem -Recurse|Measure-Object -Property Length -Sum
$SizeDasiUniqueOnUsb=Get-Item -Path H:\PromaticBackup\Unique|Get-ChildItem -Recurse|Measure-Object -Property Length -Sum
$SizeNeededForDASI=$SizeDasiWithoutUnique.Sum+($SizeDasiUnique.Sum-$SizeDasiUniqueOnUsb.Sum)
$TenPercentOfUsbDrice=($UsbDrive.Free+$UsbDrive.Used)/10

if($BackupOnUsb[$BackupOnUsb.Count-1].CreationTime.Date-ne$today){
 while($UsbDrive.Free-lt($SizeNeededForDASI+$TenPercentOfUsbDrice)){
  Write-Host(-join('"',$BackupOnUsb[$i],'"',' loeschen!'))
  Remove-Item -Path $BackupOnUsb[$i] -Force -Recurse
  $i++
 }
}
elseif($SizeNeededForDASI-gt$UsbDrive.Free){
 while($SizeNeededForDASI-gt$UsbDrive.Free){
  Write-Host(-join('"',$BackupOnUsb[$i],'"',' loeschen!'))
  Remove-Item -Path $BackupOnUsb[$i] -Force -Recurse
  $i++
 }
}
else{
 while($UsbDrive.Free-lt$TenPercentOfUsbDrice){
  Write-Host(-join('"',$BackupOnUsb[$i],'"',' loeschen!'))
  Remove-Item -Path $BackupOnUsb[$i] -Force -Recurse
  $i++
 }
}
C:\DASI\Skripte\Powershell\Working\Manage-Files\Write-Errorlog_20220301-153049.ps1 -strFolderPath ($MyInvocation.MyCommand.Path-replace($MyInvocation.MyCommand.Name,'')) -strName $MyInvocation.MyCommand.Name