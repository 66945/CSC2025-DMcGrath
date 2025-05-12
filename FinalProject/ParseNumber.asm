.386P

.model flat

extern	_ExitProcess@4:		near
extern	_GetStdHandle@4:	near
extern	_WriteConsoleA@20:	near
extern	_ReadConsoleA@20:	near

option proc:private
public ParseNumber

.data
.code

extern in_handle:			DWORD
extern out_handle:			DWORD
extern num_chars_written:	DWORD
extern num_chars_read:		DWORD
extern num_chars_to_read:	DWORD
extern read_buffer:			BYTE
extern write_buffer:		BYTE

; parses number from string
ParseNumber PROC near ; uses ebx
	; calling convention
    push	ebp         ; save old base pointer
    mov		ebp,	esp ; set stack frame base pointer

	push	ebx ; save ebx

	; function body
	mov		edx,	[ebp + 12] ; first argument - string pointer
	mov		ecx,	[ebp + 8]  ; second argument - string length (+4 because 32 bit pointer size)
	sub		ecx,	2          ; remove \n and \0

	mov		eax,	0
	mov		ebx,	0 ; clear ebx, so i can use bl

	jecxz	_parse_loop_end
_parse_loop:
	mov		bl,		[edx] ; move the first byte into ebx
	sub		bl,		30h   ; subtract '0' - convert to number

	; eax = eax * 10 + bl
	imul	eax,	10
	add		eax,	ebx

	add		edx,	1 ; next character
	loop	_parse_loop
_parse_loop_end:

	; function end
	pop		ebx ; restore ebx
	pop		ebp ; restore base pointer
	ret
ParseNumber ENDP
END
