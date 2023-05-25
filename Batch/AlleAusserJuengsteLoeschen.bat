@echo off
echo #================#
echo #=- 'AlleAusserJuengsteLoeschen.bat' - Start -=#
call C:\DASI\Skripte\Batch\JuengsteDateiAusOrdnerFiltern.bat %~1
echo alle ausser %filename% loeschen
move /y %~1\%filename% .\
del /q /f %~1
move /y .\%filename% %~1\
echo #=- 'AlleAusserJuengsteLoeschen.bat' - Ende -=#
echo #================#
:eof