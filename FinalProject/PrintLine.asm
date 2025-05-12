.386P

.model flat

extern	_ExitProcess@4:		near
extern	_GetStdHandle@4:	near
extern	_WriteConsoleA@20:	near
extern	_ReadConsoleA@20:	near

option proc:private
public PrintLine

.data
.code

extern in_handle:			DWORD
extern out_handle:			DWORD
extern num_chars_written:	DWORD
extern num_chars_read:		DWORD
extern num_chars_to_read:	DWORD
extern read_buffer:			BYTE
extern write_buffer:		BYTE

; uses the null character to terminate printing a string
PrintLine PROC ; only uses caller saved registers
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
END
