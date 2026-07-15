@echo off
REM myskills installer - Windows CMD
REM Installs ALL prompt .md files as slash commands for Claude Code, Cursor, Codex.
REM New .md files are picked up automatically - no per-file list to maintain.
setlocal enabledelayedexpansion
set "SRC=%~dp0"
if "%SRC:~-1%"=="\" set "SRC=%SRC:~0,-1%"

echo myskills installer

for %%T in ("%USERPROFILE%\.claude\commands" "%USERPROFILE%\.cursor\commands" "%USERPROFILE%\.codex\prompts") do (
  if not exist "%%~T" mkdir "%%~T"
  set /a n=0
  for /f "delims=" %%F in ('dir /b /s /a-d "%SRC%\frontend\*.md" "%SRC%\general\*.md" 2^>nul') do (
    set "F=%%F"
    set "REL=!F:%SRC%\=!"
    set "BASE=%%~nxF"
    set "DST=!BASE!"
    echo !REL! | findstr /b /i "frontend\\angular\\" >nul && set "DST=ng-!BASE!"
    echo !REL! | findstr /b /i "frontend\\hybris\\" >nul && set "DST=hybris-!BASE!"
    copy /Y "%%F" "%%~T\!DST!" >nul
    set /a n+=1
  )
  echo   installed !n! files -^> %%~T
)

echo Done.
endlocal
