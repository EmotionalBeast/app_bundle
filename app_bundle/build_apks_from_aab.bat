@echo off
REM
REM android app bundle tools
REM build .apks from aab file
REM
REM bundletool.jar version : 0.7.2
REM bundletool.jar github  : https://github.com/google/bundletool/releases
REM
REM v0.0.1
REM zengpu

title build .apks from aab file

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
echo start build *.apks files from *.aab files, please wait...
echo.

for %%f in (%cd%\%workspace%\*.aab) do (
	set target_aab=%%f 
	echo find aab file : %%f
	echo.
	)

rem enable local variable
setlocal enabledelayedexpansion
for %%f in (%cd%\%workspace%\*.aab) do (
	echo start build
	set target_aab=%%f 
	echo target aab  file : !target_aab!
	set output_apks=!target_aab:.aab=.apks!
	if exist !output_apks! (del !output_apks!)
	java -jar %bundletooljar% build-apks --bundle=!target_aab! --output=!output_apks! --ks=%ks_file% --ks-pass=%ks_pass%  --ks-key-alias=%ks_alias% --key-pass=%ks_pass%
	echo output apks file : !output_apks!
	echo finish build
	echo.
	) 
pause


