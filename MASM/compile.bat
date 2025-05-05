@echo off
ml main.asm kernel32.lib user32.lib /link /subsystem:console /entry:main
echo ===================================================================
echo.
main.exe
echo.
echo ===================================================================
