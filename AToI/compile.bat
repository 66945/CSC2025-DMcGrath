@echo off
ml AToI.asm kernel32.lib user32.lib /link /subsystem:console /entry:main
echo ===================================================================
echo.
AToI.exe
echo.
echo ===================================================================
