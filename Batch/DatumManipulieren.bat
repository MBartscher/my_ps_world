@echo off
echo #================#
echo #=- 'DatumManipulieren.bat' - Start -=#
if %date:~8,1% equ 0 set tag=%date:~9,1%
if %date:~8,1% neq 0 set tag=%date:~8,2%
set /a tag=%tag% - %~1
if %date:~5,1% equ 0 set monat=%date:~6,1%
if %date:~5,1% neq 0 set monat=%date:~5,2%
set jahr=%date:~0,4%
:Verschiebung
if %tag% lEQ 0 set /a monat=%monat%-1
if %monat% EQU 0 set /a jahr=%jahr%-1
if %monat% EQU 0 set monat=12
if %monat% EQU 1 set /a tag1=31+%tag%
if %monat% EQU 2 set /a tag1=29+%tag%
if %monat% EQU 3 set /a tag1=31+%tag%
if %monat% EQU 4 set /a tag1=30+%tag%
if %monat% EQU 5 set /a tag1=31+%tag%
if %monat% EQU 6 set /a tag1=30+%tag%
if %monat% EQU 7 set /a tag1=31+%tag%
if %monat% EQU 8 set /a tag1=31+%tag%
if %monat% EQU 9 set /a tag1=30+%tag%
if %monat% EQU 10 set /a tag1=31+%tag%
if %monat% EQU 11 set /a tag1=30+%tag%
if %monat% EQU 12 set /a tag1=31+%tag%
if %tag% lEQ 0 set tag=%tag1%
if %tag% leq 0 goto Verschiebung
set null=0
if %tag% lss 10 set tag=%null%%tag%
if %monat% lss 10 set monat=%null%%monat%
set datum=%jahr%-%monat%-%tag%
echo %datum% ist %~1 Tage her.
echo #=- 'DatumManipulieren.bat' - Ende -=#
echo #================#
:eof %datum%