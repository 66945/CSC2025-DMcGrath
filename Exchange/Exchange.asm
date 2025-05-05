.386P

.model flat

extern	_ExitProcess@4:		near
extern	_GetStdHandle@4:	near
extern	_WriteConsoleA@20:	near
extern	_ReadConsoleA@20:	near

.data
.code

main PROC near
_main:
	mov eax, 10 ; number 1
	mov ebx, 20 ; number 2
	mov ecx, 30 ; number 3
	mov edx, 40 ; number 4

	xchg eax, edx
	xchg ebx, ecx

	; exit with code 0
	push	0
	call	_ExitProcess@4
main ENDP
END
