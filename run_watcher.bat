:: filename: F:\OneDrive\vscode\vscode_py\watch_and_bundle_py\run_watcher.bat
@echo off
setlocal enabledelayedexpansion
@chcp 65001 >nul
cd /d "%~dp0"

:: DYNAMIC WINDOW NAMING: Extract current folder name to set custom taskbar branding
for %%I in ("%~dp0.") do set "FolderTitle=%%~nxI"
title Watcher: !FolderTitle!

echo =================================================================
echo  Verifying local computer environment configuration for [!FolderTitle!]...
echo =================================================================

:: Check if a usable version of Python is globally mapped on the system path
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] Python is missing from this workspace.
    echo [*] Initiating automated background deployment via Windows Package Manager...
    echo.
    
    :: Bypass Windows native execution aliases that redirect unprovisioned commands to the App Store
    powershell -Command "Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\App Paths\python.exe' -Name '(Default)' -ErrorAction SilentlyContinue" >nul 2>nul
    
    :: Silently stream and deploy the current stable core engine release via winget
    winget install --id Python.Python.3 -e --silent --accept-source-agreements --accept-package-agreements
    
    if !errorlevel! neq 0 (
        echo [X] Automated winget core pipeline deployment failed.
        echo [?] Please manually download and install Python from: https://python.org
        pause
        exit /b
    )
    
    :: DYNAMIC LOOKUP: Probe the newly installed AppData folders to discover the exact version name
    set "TARGET_VER="
    for /d %%D in ("%USERPROFILE%\AppData\Local\Programs\Python\Python3*") do (
        set "TARGET_VER=%%~nxD"
    )
    
    :: Fallback check to Program Files if User Profile installation flags were not used
    if "!TARGET_VER!"=="" (
        for /d %%D in ("%ProgramFiles%\Python3*") do (
            set "TARGET_VER=%%~nxD"
        )
    )
    
    :: If a version directory was found, dynamically append its paths to the session context instantly
    if not "!TARGET_VER!"=="" (
        set "PATH=%PATH%;%USERPROFILE%\AppData\Local\Programs\Python\!TARGET_VER!;%USERPROFILE%\AppData\Local\Programs\Python\!TARGET_VER!\Scripts;%ProgramFiles%\!TARGET_VER!;%ProgramFiles%\!TARGET_VER!\Scripts"
    )
    
    :: Final health pass to register the path additions without requiring a machine restart
    where python >nul 2>nul
    if !errorlevel! neq 0 (
        echo [!] Python engine was successfully installed, but terminal variables require a shell sync.
        echo [?] Please exit this terminal window, restart your code editor, and launch this file again.
        pause
        exit /b
    )
    echo [+] Python runtime environment successfully integrated!
) else (
    echo [+] Python environment verified.
)

echo.
echo =================================================================
echo  Installing and syncing essential helper frameworks...
echo  (First run may take 15-30 seconds to fetch packages, please watch text)
echo =================================================================

:: Upgrade pip visibly so laymen see real-time progress instead of a frozen screen
python -m pip install --upgrade pip

:: Install required UI and parsing frameworks with live output
python -m pip install watchdog docx2txt pyperclip tiktoken

echo.
echo =================================================================
echo  Launching Deep-Tree Omni-Sync Watcher and Bundler Engine...
echo =================================================================
echo.

:WATCHER_LOOP
python watch_and_bundle.py
set "EXIT_CODE=%errorlevel%"

:: Code 42 indicates an automated hot-reload triggered by a self-code update
if %EXIT_CODE% equ 42 (
    echo.
    echo =================================================================
    echo [*] Self-Update Detected: Rebooting watcher with new code...
    echo =================================================================
    echo.
    timeout /t 1 /nobreak >nul
    goto WATCHER_LOOP
)

:: If the script exited due to an error, pause so the user can fix the code without the terminal closing
if %EXIT_CODE% neq 0 (
    echo.
    echo [!] Watcher session stopped with an error (Exit Code: %EXIT_CODE%).
    echo [?] Fix the code in your editor and press any key to restart, or close this window.
    pause
    goto WATCHER_LOOP
)

echo.
echo [!] Watcher session has terminated normally.
pause