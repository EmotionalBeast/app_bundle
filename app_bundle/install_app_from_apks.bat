@echo off
REM
REM android app bundle tools
REM insall app from apks file
REM
REM bundletool.jar version : 0.7.2
REM bundletool.jar github  : https://github.com/google/bundletool/releases
REM
REM v0.0.1
REM zengpu

title insall app from apks file

set workspace=workspace
set bundletooljar=
set adbexe=
set ks_file=
set ks_alias=
set ks_pass=

rem read config
set config_path=%cd%\config
set config_file=%config_path%\config.ini
for /f "tokens=1,2 delims==" %%a in (%config_file%) do ( 
	if "bundletooljar" equ "%%a"  set bundletooljar=%config_path%\%%b 
	if "adbexe"        equ "%%a"  set adbexe=%config_path%\%%b 
	if "ks_file"       equ "%%a"  set ks_file=%config_path%\%%b 
	if "ks_alias"      equ "%%a"  set ks_alias=%%b 
	if "ks_pass"       equ "%%a"  set ks_pass=%%b 
	)

echo.
echo insall app from apks file, please wait...
echo.

rem enable local variable
setlocal enabledelayedexpansion
for %%f in (%cd%\%workspace%\*.apks) do (
	echo start install
	set target_apks=%%f 
	echo target apks file : !target_apks!
	set devicespec=!target_apks:.apks=.json!
	if exist !devicespec! ( del !devicespec! )
	java -jar %bundletooljar% get-device-spec --output=!devicespec! --adb=%adbexe%
	java -jar %bundletooljar% install-apks --apks=!target_apks! --adb=%adbexe%
	echo finish install
	echo.
	) 
pause