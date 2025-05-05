.386P

.model flat

extern	_ExitProcess@4:		near
extern	_GetStdHandle@4:	near
extern	_WriteConsoleA@20:	near
extern	_ReadConsoleA@20:	near

.data
in_handle	DD	?
out_handle	DD	?

read_buffer			DB	1024	DUP(00h)
num_chars_to_read	DD	1024
num_chars_read		DD ?

msg					DB	"Enter an input: > "
errmsg				DB	"No input provided, program exiting", 0ah
num_chars_written	DD	?

.code
main PROC near
	; Get stdin file handle
	push	-10
	call	_GetStdHandle@4
	mov		in_handle, eax

	; Get stdout file handle
	push	-11
	call	_GetStdHandle@4
	mov		out_handle, eax

loop_a:
	; WriteConsole
	push	0
	push	offset num_chars_written
	push	18
	push	offset msg
	push	out_handle
	call	_WriteConsoleA@20

	; ReadConsole
	push	0
	push	offset num_chars_read
	push	num_chars_to_read
	push	offset read_buffer
	push	in_handle
	call	_ReadConsoleA@20

	; 2 chars by default - \n\0
	cmp		num_chars_read,	2
	jg		success

	; WriteConsole
	push	0
	push	offset num_chars_written
	push	35
	push	offset errmsg
	push	out_handle
	call	_WriteConsoleA@20
	jmp		skip

success:
	; ReadConsole
	push	0
	push	offset num_chars_read
	push	num_chars_read
	push	offset read_buffer
	push	out_handle
	call	_WriteConsoleA@20
	jmp		loop_a

skip:
	; exit with code 0
	push	0
	call	_ExitProcess@4

main ENDP
END
