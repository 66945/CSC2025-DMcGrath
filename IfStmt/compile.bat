@echo off
ml IfStmt.asm kernel32.lib user32.lib /link /subsystem:console /entry:main
echo ===================================================================
echo.
IfStmt.exe
echo.
echo ===================================================================
