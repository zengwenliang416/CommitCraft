@echo off
REM CommitCraft Installation Script for Windows
REM Batch file wrapper for PowerShell installation

echo.
echo ╔═══════════════════════════════════════╗
echo ║      CommitCraft Installation         ║
echo ║   Multi-Agent Git Commit System       ║
echo ╚═══════════════════════════════════════╝
echo.

REM Check if PowerShell is available
where powershell >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] PowerShell is not installed or not in PATH.
    echo Please install PowerShell to continue.
    pause
    exit /b 1
)

REM Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Not running as administrator.
    echo Some features might not work properly.
    echo.
)

REM Set execution policy for current process
echo Setting PowerShell execution policy...
powershell -Command "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force" >nul 2>&1

REM Run PowerShell installation script
echo Starting installation...
echo.

REM Check if uninstall parameter was passed
if "%1"=="--uninstall" (
    powershell -ExecutionPolicy Bypass -File "%~dp0install.ps1" -Uninstall
) else (
    powershell -ExecutionPolicy Bypass -File "%~dp0install.ps1"
)

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Installation failed. Please check the error messages above.
    pause
    exit /b %errorlevel%
)

echo.
echo Installation completed successfully!
echo.
echo Quick Start:
echo   1. Open Claude Code
echo   2. Make some changes to your files
echo   3. Run: /commit-pilot
echo.
echo For help, run: /commit-pilot --help
echo.
pause