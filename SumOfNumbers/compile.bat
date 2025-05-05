@echo off
ml SumOfNumbers.asm kernel32.lib user32.lib /link /subsystem:console /entry:main
echo ===================================================================
echo.
SumOfNumbers.exe
echo.
echo ===================================================================
