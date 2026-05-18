@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%Start_Druckenmiller_Background.ps1"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "STARTUP_FILE=%STARTUP_DIR%\Druckenmiller_Dashboard_Server.vbs"

echo ======================================
echo Druckenmiller Dashboard Auto Start
echo ======================================
echo Installing Windows login startup file...

if not exist "%STARTUP_DIR%" mkdir "%STARTUP_DIR%"
if errorlevel 1 (
    echo.
    echo Failed to find or create the Windows Startup folder.
    pause
    exit /b 1
)

> "%STARTUP_FILE%" echo Set shell = CreateObject("WScript.Shell")
>> "%STARTUP_FILE%" echo shell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File ""%PS_SCRIPT%""", 0, False
if errorlevel 1 (
    echo.
    echo Failed to write the startup file.
    pause
    exit /b 1
)

echo.
echo Starting the server now...
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%PS_SCRIPT%"

echo.
echo Installed. After Windows login, the dashboard server will start automatically.
echo Startup file: %STARTUP_FILE%
echo Open: http://127.0.0.1:8080
pause
