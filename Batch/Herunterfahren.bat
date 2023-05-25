@echo off
echo #================#
echo #=- "Herunterfahren.bat" - Start -=#
echo Backup durchfuehren...
call "C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\DASI\Skripte\Batch\Backup.bat"
echo fertig!
echo Aufraeumen:
Powershell.exe -executionpolicy remotesigned -File  "C:\Users\m.bartscher\OneDrive - promatic Automatisierungssysteme GmbH\DASI\Skripte\Powershell\Working\Manage-System\Cleanup-System_20220520-73600.ps1" -verbose
echo herunter fahren...
shutdown /s /f /t 0