;---ASM Hello World Win32 MessageBox

.386
.model flat, stdcall
; include    kernel32.inc
includelib kernel32.lib
; include    user32.inc
includelib user32.lib

.data
title db 'Win32', 0
msg db 'Hello World', 0

.code

main:
push 0            ; uType = MB_OK
push offset title ; LPCSTR lpCaption
push offset msg   ; LPCSTR lpText
push 0            ; hWnd = HWND_DESKTOP
call MessageBoxA
push eax          ; uExitCode = MessageBox(...)
call ExitProcess

End main
