@echo off
rem Just a wrapper to run the matching PowerShell script.
pushd %~dp0
PowerShell.exe -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Unrestricted -Command "& '%~dp0Program-LedHex.ps1'"
pause
popd