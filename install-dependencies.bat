@echo off
REM ABOUTME: Installs AI CLI dependencies (Claude Code, Gemini, Codex)
REM          Checks for Node.js/npm and installs missing tools

setlocal EnableDelayedExpansion

echo.
echo ========================================
echo   AI Context Tools - Dependency Installer
echo ========================================
echo.

REM Check for Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] Node.js is NOT installed
    echo.
    echo Node.js is required to install Claude Code CLI.
    echo.
    echo Would you like to open the Node.js download page?
    choice /C YN /M "Open download page"
    if !errorlevel! equ 1 (
        start https://nodejs.org/
        echo.
        echo After installing Node.js, run this script again.
    )
    pause
    exit /b 1
)

echo [OK] Node.js found
for /f "tokens=*" %%i in ('node --version') do echo     Version: %%i
echo.

REM Check for npm
where npm >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] npm is NOT installed (should come with Node.js)
    echo     Please reinstall Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo [OK] npm found
for /f "tokens=*" %%i in ('npm --version') do echo     Version: %%i
echo.

echo ========================================
echo   Checking AI CLI Tools
echo ========================================
echo.

REM Check Claude Code
where claude >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] Claude Code CLI is installed
    for /f "tokens=*" %%i in ('claude --version 2^>nul') do echo     Version: %%i
    set CLAUDE_INSTALLED=1
) else (
    echo [--] Claude Code CLI is NOT installed
    set CLAUDE_INSTALLED=0
)

REM Check Gemini
where gemini >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] Gemini CLI is installed
    set GEMINI_INSTALLED=1
) else (
    echo [--] Gemini CLI is NOT installed
    set GEMINI_INSTALLED=0
)

REM Check Codex
where codex >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] Codex CLI is installed
    set CODEX_INSTALLED=1
) else (
    echo [--] Codex CLI is NOT installed
    set CODEX_INSTALLED=0
)

echo.
echo ========================================
echo   Install Options
echo ========================================
echo.
echo Which AI CLI would you like to install?
echo.
echo   [1] Claude Code CLI (recommended for AI-Assisted Conversion)
echo   [2] Gemini CLI
echo   [3] Codex CLI
echo   [4] Install ALL
echo   [5] Skip / Exit
echo.

choice /C 12345 /M "Select option"
set CHOICE=%errorlevel%

if %CHOICE% equ 5 goto :done

echo.
echo Installing... (this may take a minute)
echo.

if %CHOICE% equ 1 goto :install_claude
if %CHOICE% equ 2 goto :install_gemini
if %CHOICE% equ 3 goto :install_codex
if %CHOICE% equ 4 goto :install_all

:install_claude
echo Installing Claude Code CLI...
echo Command: npm install -g @anthropic-ai/claude-code
echo.
call npm install -g @anthropic-ai/claude-code
if %errorlevel% equ 0 (
    echo.
    echo [OK] Claude Code CLI installed successfully!
    echo.
    echo To verify, run: claude --version
    echo.
    echo IMPORTANT: You need an Anthropic API key to use Claude Code.
    echo Get one at: https://console.anthropic.com/
    echo Then run: claude (it will prompt for your API key)
) else (
    echo.
    echo [!] Installation failed. Try running as Administrator.
)
if %CHOICE% neq 4 goto :done
goto :install_gemini

:install_gemini
echo Installing Gemini CLI...
echo Command: npm install -g @anthropic-ai/gemini-cli
echo.
call npm install -g @google/gemini-cli 2>nul
if %errorlevel% equ 0 (
    echo.
    echo [OK] Gemini CLI installed successfully!
) else (
    echo.
    echo [!] Gemini CLI installation failed or package not found.
    echo     Check https://ai.google.dev/gemini-api/docs for installation instructions.
)
if %CHOICE% neq 4 goto :done
goto :install_codex

:install_codex
echo Installing Codex CLI...
echo Command: npm install -g @openai/codex
echo.
call npm install -g @openai/codex 2>nul
if %errorlevel% equ 0 (
    echo.
    echo [OK] Codex CLI installed successfully!
) else (
    echo.
    echo [!] Codex CLI installation failed or package not found.
    echo     Check https://platform.openai.com/docs for installation instructions.
)
goto :done

:install_all
goto :install_claude

:done
echo.
echo ========================================
echo   Done!
echo ========================================
echo.
echo After installing, run the AI Context Tools installer
echo to add right-click context menu integration.
echo.
pause
