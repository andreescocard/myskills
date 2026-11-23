@echo off
REM myskills installer - Windows CMD. Runs install.ps1; extra options pass through:
REM   install.bat -WithAgents -WithSettings
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
