@echo off
REM ABOUTME: Launches Claude Code with file conversion context
REM          Gives AI knowledge of ffmpeg, FileConverter presets, and conversion capabilities

REM Check if Claude CLI is available
where claude >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: Claude Code CLI not found in PATH
    echo.
    echo Please install Claude Code CLI using:
    echo   npm install -g @anthropic-ai/claude-code
    echo.
    pause
    exit /b 1
)

REM Validate input parameter
if "%~1"=="" (
    echo ERROR: No file provided
    echo Usage: ai-convert.bat "path\to\file.mp4"
    pause
    exit /b 1
)

REM Check if the target exists
if not exist "%~1" (
    echo ERROR: File "%~1" does not exist
    pause
    exit /b 1
)

REM Get file info
set "FILE_PATH=%~1"
set "FILE_NAME=%~nx1"
set "FILE_EXT=%~x1"
set "FILE_DIR=%~dp1"

echo.
echo ========================================
echo   AI-Assisted File Conversion
echo ========================================
echo.
echo File: %FILE_NAME%
echo Location: %FILE_DIR%
echo.
echo Launching Claude Code with conversion context...
echo.

REM Build the prompt with file context
set "PROMPT=I need help converting this file: %FILE_NAME%"

REM Launch Claude Code with the conversion prompt
where wt >nul 2>nul
if %errorlevel% equ 0 (
    REM Windows Terminal available
    start "AI Convert" wt -d "%FILE_DIR%" cmd /k "claude --print ""You are a file conversion assistant. The user wants to convert: %FILE_NAME% (located at %FILE_PATH%). Analyze this file and help them convert it. You have access to ffmpeg, ffprobe, and ImageMagick. Ask clarifying questions about their goal (smaller size? different format? quality preference?) then perform the conversion."" & echo. & echo Type your conversion request above, or ask me to analyze the file first. & echo. & claude"
) else (
    REM Fallback to cmd
    start "AI Convert" cmd /k "cd /d ""%FILE_DIR%"" && claude --print ""You are a file conversion assistant. The user wants to convert: %FILE_NAME% (located at %FILE_PATH%). Analyze this file and help them convert it. You have access to ffmpeg, ffprobe, and ImageMagick. Ask clarifying questions about their goal (smaller size? different format? quality preference?) then perform the conversion."" & echo. & echo Type your conversion request above, or ask me to analyze the file first. & echo. & claude"
)
