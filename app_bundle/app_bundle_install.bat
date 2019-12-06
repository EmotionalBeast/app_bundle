@echo off
REM
REM android app bundle tool
REM install apk from aab file for a target device
REM
REM bundletool.jar version : 0.7.2
REM bundletool.jar github  : https://github.com/google/bundletool/releases
REM
REM v0.0.1
REM zengpu
REM

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
echo start install apps from *.aab files, please wait...
echo.

for  %%f in (%cd%\%workspace%\*.aab) do (
	echo find aab file : %%f
	echo.
	)


rem create a tmp file to save device info
set tmpdeviceinfofile=%cd%\%workspace%\tmpdeviceinfo.txt
if exist %tmpdeviceinfofile% (del %tmpdeviceinfofile%)

rem start adb shell for device
setlocal enabledelayedexpansion
%adbexe% start-server
%adbexe% shell getprop ro.product.model >%tmpdeviceinfofile%
%adbexe% shell getprop ro.build.version.release >>%tmpdeviceinfofile%
%adbexe% shell getprop ro.build.version.sdk >>%tmpdeviceinfofile%

set suffix=
for /f "delims=" %%a in (%tmpdeviceinfofile%) do ( 
	set "tmp=%%a"
	set "tmp=!tmp: =_!"
	set suffix=!suffix!_!tmp!
	)

rem save info into tmpdeviceinfofile.txt
echo %suffix% >%tmpdeviceinfofile%
endlocal

rem read the device info  into a global var
set device_info_suffix=
for /f  %%a in (%tmpdeviceinfofile%) do ( 
	set device_info_suffix=%%a
	)

set SDK_VERSION=%device_info_suffix:~-2,2%
echo.
echo device_sdk_version=%SDK_VERSION%
echo.

rem delete tmp file
if exist %tmpdeviceinfofile% (del %tmpdeviceinfofile%)

setlocal enabledelayedexpansion
for  %%f in (%cd%\%workspace%\*.aab) do (

	echo start build

	set target_aab=%%f 
	echo target aab  file : !target_aab!

	set out_path=!target_aab:.aab=!
	set out_path=!out_path!!device_info_suffix!
	set out_path=!out_path: =!

	rem get device spec
	set output_devicespec=!out_path!.json
	if exist !output_devicespec! ( del !output_devicespec! )

	java -jar %bundletooljar% get-device-spec --output=!output_devicespec! --adb=%adbexe%

	echo output device spec : !output_devicespec!
	echo.
	for /f "delims=" %%a in (!output_devicespec!) do ( 
		echo %%a
		)
	echo.
	set output_apks=!out_path!.apks
	if exist !output_apks! (del !output_apks!)

	java -jar %bundletooljar% build-apks --connected-device --adb=%adbexe% --bundle=!target_aab! --output=!output_apks! --ks=%ks_file% --ks-pass=%ks_pass%  --ks-key-alias=%ks_alias% --key-pass=%ks_pass%

	echo output apks file : !output_apks!
	echo finish build
	echo.

	echo start install on device !device_info_suffix!
	java -jar %bundletooljar% install-apks --apks=!output_apks! --adb=%adbexe%
	echo finish install on device !device_info_suffix!
	echo.
	)
pause

