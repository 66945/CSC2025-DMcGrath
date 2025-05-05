@echo off
ml Fibonacci.asm kernel32.lib user32.lib /link /subsystem:console /entry:main
echo ===================================================================
echo.
Fibonacci.exe
echo.
echo ===================================================================
