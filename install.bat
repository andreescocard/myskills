@echo off
REM myskills installer - Windows CMD
REM Installs prompt files as slash commands for Claude Code, Cursor, Codex.
setlocal enabledelayedexpansion
set "SRC=%~dp0"

echo myskills installer

for %%T in ("%USERPROFILE%\.claude\commands" "%USERPROFILE%\.cursor\commands" "%USERPROFILE%\.codex\prompts") do (
  if not exist "%%~T" mkdir "%%~T"
  copy /Y "%SRC%frontend\angular\safetoship.md"     "%%~T\ng-safetoship.md" >nul
  copy /Y "%SRC%frontend\angular\safetoshiplite.md" "%%~T\ng-safetoshiplite.md" >nul
  copy /Y "%SRC%frontend\hybris\safetoship.md"      "%%~T\hybris-safetoship.md" >nul
  copy /Y "%SRC%frontend\hybris\safetoshiplite.md"  "%%~T\hybris-safetoshiplite.md" >nul
  copy /Y "%SRC%general\befable\befablefull.md"     "%%~T\befablefull.md" >nul
  copy /Y "%SRC%general\befable\befablelite.md"     "%%~T\befablelite.md" >nul
  copy /Y "%SRC%general\befable\befableplan.md"     "%%~T\befableplan.md" >nul
  copy /Y "%SRC%general\befable\befablerun.md"      "%%~T\befablerun.md" >nul
  echo   installed -^> %%~T
)

echo Done. Use: /ng-safetoship /hybris-safetoship /befablefull etc.
endlocal
