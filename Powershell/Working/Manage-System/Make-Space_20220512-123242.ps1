



$UsbDrive=Get-PSDrive H

[int]$i=0
$BackupOnUsb=Get-ChildItem -Path H:\PromaticBackup -Exclude 'Unique'|Sort-Object -Property CreationTime
$today=Get-Date
$today=$today.Date
$SizeDasiWithoutUnique=Get-Item -Path "C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\DASI"|Get-ChildItem -Recurse|Where-Object{!($_.FullName-like'*Unique*')}|Measure-Object -Property Length -Sum
$SizeDasiUnique=Get-Item -Path "C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\DASI\Unique"|Get-ChildItem -Recurse|Measure-Object -Property Length -Sum
$SizeDasiUniqueOnUsb=Get-Item -Path H:\PromaticBackup\Unique|Get-ChildItem -Recurse|Measure-Object -Property Length -Sum
$SizeNeededForDASI=$SizeDasiWithoutUnique.Sum+($SizeDasiUnique.Sum-$SizeDasiUniqueOnUsb.Sum)
$TenPercentOfUsbDrice=($UsbDrive.Free+$UsbDrive.Used)/10

if($BackupOnUsb[$BackupOnUsb.Count-1].CreationTime.Date-ne$today){
 while($UsbDrive.Free-lt($SizeNeededForDASI+$TenPercentOfUsbDrice)){
  Write-Verbose(-join('"',$BackupOnUsb[$i],'"',' loeschen!'))
  Remove-Item -Path $BackupOnUsb[$i] -Force -Recurse
  $i++
 }
}
elseif($SizeNeededForDASI-gt$UsbDrive.Free){
 while($SizeNeededForDASI-gt$UsbDrive.Free){
  Write-Verbose(-join('"',$BackupOnUsb[$i],'"',' loeschen!'))
  Remove-Item -Path $BackupOnUsb[$i] -Force -Recurse
  $i++
 }
}
else{
 while($UsbDrive.Free-lt$TenPercentOfUsbDrice){
  Write-Verbose(-join('"',$BackupOnUsb[$i],'"',' loeschen!'))
  Remove-Item -Path $BackupOnUsb[$i] -Force -Recurse
  $i++
 }
}