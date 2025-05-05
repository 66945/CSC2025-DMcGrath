.386P

.model flat

extern	_ExitProcess@4:		near
extern	_GetStdHandle@4:	near
extern	_WriteConsoleA@20:	near
extern	_ReadConsoleA@20:	near

.data
num_chars_written	DD	?
num_chars_read		DD	?
num_chars_to_read	DD	1024
read_buffer			DB	1024	DUP(00h)

enter_msg	DB	"Enter a number > ", 00h
debug_print	DB	"==== DEBUG ====", 0ah, 00h

test_parse_string	DB	"1024", 00h

number		DD	50
out_handle	DD	?
in_handle	DD	?

.code

; @arg str null terminated string
PrintLine PROC near
	; make a new stack frame
	push	ebp
	mov		ebp,	esp
	and		esp,	0fffffff0h

	mov		ebx,	[ebp+8]
	mov		edx,	0

	; loop
_print_line_loop:
	mov		eax,	[ebx]
	cmp		ah,		0
	je		_end_loop

	add		edx,	1
	add		ebx,	1
	jmp		_print_line_loop
_end_loop:

	; WriteConsole
	push	0
	push	offset num_chars_written
	push	edx
	push	[ebp+8]
	push	out_handle
	call	_WriteConsoleA@20

	; set eax (return 0)
	mov		eax,	0

	mov		esp,	ebp
	pop		ebp
	ret
PrintLine ENDP

ParseNumber PROC near
	push	ebp
	mov		ebp,	esp
	and		esp,	0fffffff0h

	; parameters
	; ptr -> string
	mov		edx,	[ebp+8]
	mov		ecx,	[ebp+16]

	; TODO: change to use a loop instruction
	mov		ebx,	0
_parse_loop:
	mov		cl,		[edx]

	; convert from ascii to number
	sub		cl,		48
	mov		eax,	10
	mul		ebx
	add		ebx,	ecx

	add		edx,	1

	loop _parse_loop

	mov		eax,	ebx
	mov		esp,	ebp
	pop		ebp
	ret
ParseNumber ENDP

main PROC near
	; Get stdout file handle
	push	-11
	call	_GetStdHandle@4
	mov		out_handle, eax

	; Get stdin file handle
	push	-10
	call	_GetStdHandle@4
	mov		in_handle, eax

	; write console "enter a number"
	push	offset enter_msg
	call	PrintLine

	; ReadConsole
	push	0
	push	offset num_chars_read
	push	num_chars_to_read
	push	offset read_buffer
	push	in_handle
	call	_ReadConsoleA@20

	push	offset debug_print
	call	PrintLine

	push	offset read_buffer
	push	num_chars_read
	call	ParseNumber
	cmp		eax,	0	
	jne		_else_fallthrough

	push	offset debug_print
	call	PrintLine

_else_fallthrough:

	; TODO: fibonacci

	push	offset debug_print
	call	PrintLine

	; exit with code 0
	push	0
	call	_ExitProcess@4

main ENDP
END
