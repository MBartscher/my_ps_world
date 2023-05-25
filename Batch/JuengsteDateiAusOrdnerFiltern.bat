@echo off
echo #================#
echo #=- 'JuengsteDateiAusOrdnerFiltern.bat' - Start -=#
md .\tmp
dir %~1 /b /a:-d /o:-d /t:c > .\tmp\tmp.txt
set /p filename=< .\tmp\tmp.txt
del /q /f /s .\tmp\tmp.txt
rd .\tmp
echo juengste Datei: %filename%
echo #=- 'JuengsteDateiAusOrdnerFiltern.bat' - Ende -=#
echo #================#
:eof %filename%