@echo off
ml FinalProject.asm PrintLine.asm ParseNumber.asm FmtNumber.asm kernel32.lib user32.lib /link /subsystem:console /entry:main
echo ===================================================================
echo.
FinalProject.exe
echo.
echo ===================================================================
