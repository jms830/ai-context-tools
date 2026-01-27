@echo off
REM AI-Convert Configuration
REM Copy this file to "config.bat" and customize as needed
REM The config.bat file will be loaded by ai-convert.bat if present

REM ============================================
REM  AI Tool Selection
REM ============================================
REM Which AI CLI to use? Options: claude, gemini, codex
set "AI_TOOL=claude"

REM ============================================
REM  Default Behaviors
REM ============================================
REM Show file analysis before asking for goals? (1=yes, 0=no)
set "AUTO_ANALYZE=1"

REM Preferred terminal: wt (Windows Terminal) or cmd
set "PREFERRED_TERMINAL=wt"

REM ============================================
REM  Tool Paths (if not in PATH)
REM ============================================
REM Uncomment and set if tools aren't in your PATH
REM set "FFMPEG_PATH=C:\tools\ffmpeg\bin\ffmpeg.exe"
REM set "FFPROBE_PATH=C:\tools\ffmpeg\bin\ffprobe.exe"
REM set "MAGICK_PATH=C:\Program Files\ImageMagick\magick.exe"

REM ============================================
REM  Output Preferences
REM ============================================
REM Default output directory (empty = same as input file)
set "OUTPUT_DIR="

REM Add suffix to output filename? (e.g., "_converted")
set "OUTPUT_SUFFIX="
