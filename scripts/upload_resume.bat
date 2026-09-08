@echo off
REM Double-click this file to run upload_resume.ps1 and see the output.
REM EDIT the path below if you move upload_resume.ps1 somewhere else.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0upload_resume.ps1"

echo.
echo ============================
echo Done. Press any key to close.
echo ============================
pause >nul
