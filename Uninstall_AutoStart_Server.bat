@echo off
setlocal

set "TASK_NAME=Druckenmiller Dashboard Server"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "STARTUP_FILE=%STARTUP_DIR%\Druckenmiller_Dashboard_Server.vbs"
set "OLD_STARTUP_FILE=%STARTUP_DIR%\Druckenmiller_Dashboard_Server.cmd"

echo ======================================
echo Druckenmiller Dashboard Auto Start
echo ======================================
echo Removing Windows login startup file...

if exist "%STARTUP_FILE%" del "%STARTUP_FILE%"
if exist "%OLD_STARTUP_FILE%" del "%OLD_STARTUP_FILE%"
schtasks /Delete /TN "%TASK_NAME%" /F >nul 2>&1

echo.
echo Removed. This does not stop a server that is already running now.
pause
