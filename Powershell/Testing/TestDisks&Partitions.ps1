$usb=Get-PhysicalDisk|Where-Object{$_.bustype-eq'usb'}
$volumes=Get-Volume|Where-Object{$_.DriveType-eq'Removable'}
$usb
$volumes