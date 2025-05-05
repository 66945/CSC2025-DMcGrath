.386P

.model flat

extern	_ExitProcess@4:		near
extern	_GetStdHandle@4:	near
extern	_WriteConsoleA@20:	near

.data
msg			DB	"Hello World!", 0ah
out_handle	DD	?
written		DD	?

.code
main PROC near

	; Get stdout file handle
	push	-11
	call	_GetStdHandle@4
	mov		out_handle, eax

	; WriteConsole(handle, &msg, 13, &written, 0)
	push	0
	push	offset written
	push	13
	push	offset msg
	push	out_handle
	call	_WriteConsoleA@20

	; exit with code 0
	push	0
	call	_ExitProcess@4

main ENDP
END
