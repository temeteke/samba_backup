@echo off

rem %0がダブルクリックで実行した場合は"がついてコマンドプロンプトから実行した場合"がつかないので置換で"をとる
set pathBat=%0
set pathBat=%pathBat:"=%

for /f "delims=\" %%i in ("%pathBat%") do set host=%%i

set pathPrivate=\\%host%\private\backup\%COMPUTERNAME%
set pathPublic=\\%host%\public\backup\%COMPUTERNAME%

set excludeDir=Temp

set logDir=%pathPrivate%\log
set logFile=%logDir%\%date:~-10,4%%date:~-5,2%%date:~-2,2%.log
set pathFile=%pathPrivate%\path.txt

if not exist %pathPrivate% (mkdir %pathPrivate%)
if not exist %pathPublic% (mkdir %pathPublic%)
if not exist %logDir% (mkdir %logDir%)

if defined USERPROFILE (call :copy "%USERPROFILE%" "%pathPrivate%")
if defined PUBLIC (call :copy "%PUBLIC%" "%pathPublic%")
if defined ALLUSERPROFILE (call :copy "%ALLUSERPROFILE%" "%pathPublic%")
if defined ProgramData (call :copy "%ProgramData%" "%pathPublic%")
if exist %pathFile% for /f "delims=" %%i in (%pathFile%) do call :copy "%%i" "%pathPrivate%"
goto :EOF

:copy
set pathFrom=%1
set pathFrom=%pathFrom:"=%
set pathTo=%2
set pathTo=%pathTo:"=%
if exist "%pathFrom%" ROBOCOPY "%pathFrom%" "%pathTo%\%pathFrom::=%" /MIR /E /XD %excludeDir% /XO /XJ /FFT /R:1 /W:0 /LOG+:%logfile% /TEE /NP
goto :EOF
