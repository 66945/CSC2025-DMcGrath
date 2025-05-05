.386P

.model flat

extern	_ExitProcess@4:		near
extern	_GetStdHandle@4:	near
extern	_WriteConsoleA@20:	near
extern	_ReadConsoleA@20:	near

.data
out_handle			DD	?
num_chars_written	DD	?
num_chars_read		DD	?

out_message DB "Hello world, how are you doing today?", 0ah, 00h

.code

; uses the null character to terminate printing a string
PrintLine PROC near ; only uses caller saved registers
	; calling convention
    push	ebp         ; save old base pointer
    mov		ebp,	esp ; set stack frame base pointer

	mov		ecx,	[ebp+8]
	mov		edx,	0

	; loop
_print_line_loop:
	mov		eax,	[ecx]
	cmp		ah,		0
	je		_end_loop

	add		edx,	1
	add		ecx,	1
	jmp		_print_line_loop
_end_loop:
	add	edx,	1

	; WriteConsole
	push	0
	push	offset num_chars_written
	push	edx
	push	[ebp + 8]
	push	out_handle
	call	_WriteConsoleA@20

	; set eax (return string length)
	mov		eax,	edx

	; function end
	pop		ebp ; restore base pointer
	ret
PrintLine ENDP

main PROC near
_main:
	; Get stdout file handle
	push	-11
	call	_GetStdHandle@4
	mov		out_handle, eax

	push offset out_message
	call PrintLine

	; exit with code 0
	push	0
	call	_ExitProcess@4
main ENDP
END
