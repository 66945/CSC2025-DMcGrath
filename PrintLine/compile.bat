@echo off
ml PrintLine.asm kernel32.lib user32.lib /link /subsystem:console /entry:main
echo ===================================================================
echo.
PrintLine.exe
echo.
echo ===================================================================
