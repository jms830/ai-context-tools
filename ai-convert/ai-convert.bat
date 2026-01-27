@echo off
REM ABOUTME: Launches Claude Code with file conversion context
REM          Points Claude to AGENTS.md in the install directory for conversion knowledge
REM VERSION: 1.3.0

setlocal EnableDelayedExpansion

REM Get script directory (where AGENTS.md lives)
set "SCRIPT_DIR=%~dp0"
set "AGENTS_FILE=%SCRIPT_DIR%AGENTS.md"
set "CONFIG_FILE=%SCRIPT_DIR%config.bat"

REM ============================================
REM  Load Config (if exists)
REM ============================================
set "AI_TOOL=claude"
set "AUTO_ANALYZE=1"
set "PREFERRED_TERMINAL=wt"
set "OUTPUT_DIR="
set "OUTPUT_SUFFIX="

if exist "%CONFIG_FILE%" (
    call "%CONFIG_FILE%"
)

REM ============================================
REM  Check AI CLI
REM ============================================
where %AI_TOOL% >nul 2>nul
if %errorlevel% neq 0 (
    echo.
    echo  ╔══════════════════════════════════════════════════════════╗
    echo  ║  %AI_TOOL% CLI is not installed                            
    echo  ╚══════════════════════════════════════════════════════════╝
    echo.
    echo  To install:
    echo.
    if "%AI_TOOL%"=="claude" (
        echo    npm install -g @anthropic-ai/claude-code
    ) else if "%AI_TOOL%"=="gemini" (
        echo    See: https://ai.google.dev/gemini-api/docs
    ) else if "%AI_TOOL%"=="codex" (
        echo    See: https://platform.openai.com/docs
    )
    echo.
    echo  Or run "Install Dependencies" from the Start Menu.
    echo.
    choice /C YN /M "Open Node.js download page (needed for npm)"
    if !errorlevel! equ 1 start https://nodejs.org/
    pause
    exit /b 1
)

REM ============================================
REM  Validate Input
REM ============================================
if "%~1"=="" (
    echo.
    echo  Usage: ai-convert.bat "path\to\file"
    echo.
    echo  Right-click any file and select:
    echo    AI Tools ^> Convert with AI Help
    echo.
    pause
    exit /b 1
)

if not exist "%~1" (
    echo.
    echo  ERROR: File not found
    echo  Path: %~1
    echo.
    pause
    exit /b 1
)

REM ============================================
REM  Get File Info
REM ============================================
set "FILE_PATH=%~f1"
set "FILE_NAME=%~nx1"
set "FILE_EXT=%~x1"
set "FILE_DIR=%~dp1"

REM Determine output directory
if "%OUTPUT_DIR%"=="" (
    set "OUT_DIR=%FILE_DIR%"
) else (
    set "OUT_DIR=%OUTPUT_DIR%"
)

echo.
echo  ╔══════════════════════════════════════════════════════════╗
echo  ║  AI-Assisted File Conversion                             ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
echo  File:     %FILE_NAME%
echo  Location: %FILE_DIR%
echo  AI Tool:  %AI_TOOL%
echo.
echo  Launching %AI_TOOL%...
echo.

REM ============================================
REM  Build Prompt
REM ============================================
set "INIT_PROMPT=First, read the conversion knowledge from: %AGENTS_FILE% - Then help me convert this file: %FILE_PATH% - Analyze it with ffprobe or magick identify, ask about my goals, and perform the conversion. Output files should go to: %OUT_DIR%"

REM ============================================
REM  Launch AI
REM ============================================
set "USE_WT=0"
if "%PREFERRED_TERMINAL%"=="wt" (
    where wt >nul 2>nul
    if !errorlevel! equ 0 set "USE_WT=1"
)

if "%USE_WT%"=="1" (
    start "AI Convert" wt -d "%FILE_DIR%" cmd /k "%AI_TOOL% ""%INIT_PROMPT%"""
) else (
    start "AI Convert" cmd /k "cd /d ""%FILE_DIR%"" && %AI_TOOL% ""%INIT_PROMPT%"""
)

endlocal
