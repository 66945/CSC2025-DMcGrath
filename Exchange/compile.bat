@echo off
ml Exchange.asm kernel32.lib user32.lib /link /subsystem:console /entry:main
echo ===================================================================
echo.
Exchange.exe
echo.
echo ===================================================================
