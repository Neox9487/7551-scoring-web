@echo off
setlocal enabledelayedexpansion
title System Launcher
set PORT=3001

:CHECK_NODE
node -v >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: Node.js is not installed.
    echo Please install it from https://nodejs.org/
    pause
    exit
)
echo Node.js is installed.

:CHECK_NPM
call npm -v >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: NPM is not installed. 
    echo Usually, this comes with Node.js. Check your installation.
    pause
    exit
)
echo NPM is installed.

:MENU
cls
echo  1. Start Local Mode    (Localhost only)
echo  2. Start Global Mode   (With ngrok tunnel)
echo  3. Run Setup Only      (Install Dependencies/Build)
echo  4. Exit
set /p choice="Please enter your choice (1-4): "

if "%choice%"=="1" goto :SET_LOCAL
if "%choice%"=="2" goto :CHECK_NGROK
if "%choice%"=="3" goto :CHECK_DEPENDENCIES
if "%choice%"=="4" exit
goto :MENU

:SET_LOCAL
set MODE=LOCAL
goto :DB_CONFIG

:CHECK_NGROK
echo Checking for ngrok...
ngrok -v >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Ngrok is not installed or not in PATH.
    echo Global Mode requires ngrok to function.
    echo Please install it from https://ngrok.com/
    pause
    goto :MENU
)
echo Ngrok is installed.
set MODE=NGROK
goto :DB_CONFIG

:DB_CONFIG
echo.
set /p DB_USER="Enter MySQL Username (default: root): "
if "%DB_USER%"=="" set DB_USER=root

set /p DB_PASSWORD="Enter MySQL Password (leave blank if none): "
goto :CHECK_DEPENDENCIES

:CHECK_DEPENDENCIES
cls
echo [1/2] Validating Frontend...
cd /d "%~dp0client"
if not exist "node_modules" (
    echo Installing client-side packages...
    call npm install
)
echo Building frontend distribution...
call npm run build

echo.
echo [2/2] Validating Backend...
cd /d "%~dp0server"
if not exist "node_modules" (
    echo Installing server-side packages...
    call npm install
)

if "%choice%"=="3" (
    echo.
    echo Setup Complete!
    pause
    goto :MENU
)
goto :RUN_SERVER

:RUN_SERVER
cls
echo SYSTEM RUNNING IN [%MODE%] MODE
cd /d "%~dp0server"

set DB_USER=%DB_USER%
set DB_PASSWORD=%DB_PASSWORD%
set DB_HOST=localhost

if "%MODE%"=="LOCAL" (
    echo [INFO] Server URL: http://localhost:%PORT%
    echo [INFO] Press Ctrl+C twice to stop the server.
    echo.
    node index.js
) else (
    echo [INFO] Starting Backend in background...
    start /b "FRC_Backend" node index.js
    timeout /t 3 >nul
    echo [INFO] Launching ngrok tunnel...
    echo.
    ngrok http %PORT%
)

set EXIT_CODE=%ERRORLEVEL%

if "%EXIT_CODE%"=="1" (
    echo.
    echo [!] ERROR 1: DATABASE CONNECTION FAILED
    pause
) else if "%EXIT_CODE%"=="2" (
    echo.
    echo [!] ERROR 2: SERVER STARTUP FAILED
    pause
)

echo.
echo [SYSTEM] Process ended.
timeout /t 2 >nul
goto :MENU