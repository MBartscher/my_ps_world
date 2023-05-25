@echo off
echo #================#
echo #=- 'Aufraeumen.bat' - Start -=#
echo Recycle Bin leeren...
del /q /f /s C:\$RECYCLE.BIN\*
echo fertig!
echo temproraere Dateien loeschen...
del /q /f /s %temp%\*
del /q /f /s C:\Temp\*
del /q /f /s C:\Users\m.bartscher.PROMATIC\Documents\Automatisierung\TIA\Temp\*
del /q /f /s C:\tmp\*
echo fertig!
echo Downloads aufraeumen...
del /q /f /s C:\Users\m.bartscher\Downloads\simatic\*
echo fertig!
echo #=- 'Aufraeumen.bat' - Ende -=#
echo #================#
:eof