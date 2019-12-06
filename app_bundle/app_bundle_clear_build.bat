@echo off
REM
REM clear app bundle build cache
REM
REM v0.0.1
REM zengpu

echo.
echo start clear build
REM delete file
set workspace=workspace
for %%f in (%cd%\%workspace%\*.apks,%cd%\%workspace%\*.json) do (
	echo delete file : %%f
	del %%f
	)

REM delete directory
set folder=%cd%\%workspace%\
for /f "delims=" %%f in ( 'dir /ad /b %folder%') do (
	echo delete dir : %folder%%%f
	rd /s /q %folder%%%f
	)

echo clear build finish!

pause