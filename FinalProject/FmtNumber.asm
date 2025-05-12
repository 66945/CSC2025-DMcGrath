.386P

.model flat

extern	_ExitProcess@4:		near
extern	_GetStdHandle@4:	near
extern	_WriteConsoleA@20:	near
extern	_ReadConsoleA@20:	near

option proc:private
public FmtNumber

.data
.code

extern in_handle:			DWORD
extern out_handle:			DWORD
extern num_chars_written:	DWORD
extern num_chars_read:		DWORD
extern num_chars_to_read:	DWORD
extern read_buffer:			BYTE
extern write_buffer:		BYTE

; owns write_buffer for the sake of convenience
; takes in a number
FmtNumber PROC near
	; calling convention
    push	ebp         ; save old base pointer
    mov		ebp,	esp ; set stack frame base pointer

	push 	ebx ; save ebx
	mov		ebx,	offset write_buffer
	add		ebx,	1022 ; buffer end before null terminator

	; function body
	mov		eax,	[ebp + 8] ; argument - number to print

_number_loop:
	mov		edx,	0  ; clear dividend
	mov		ecx,	10 ; divisor
	div		ecx        ; eax = eax / ecx, edx = eax % ecx

	; add to buffer
	; mov		bl,		dl
	add		dl,		30h ; += '0'
	mov		[ebx],	dl
	sub		ebx,	1

	; terminate loop
	cmp		eax,	0
	jne		_number_loop
_end_number_loop:

	; returns nothing
	mov		eax,	ebx
	add		eax,	1

	; function end
	pop		ebx ; restore ebx
	pop		ebp ; restore base pointer
	ret
FmtNumber ENDP
END
