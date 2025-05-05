.386P

.model flat

extern	_ExitProcess@4:		near
extern	_GetStdHandle@4:	near
extern	_WriteConsoleA@20:	near
extern	_ReadConsoleA@20:	near

.data
in_handle			DD	?
out_handle			DD	?
num_chars_written	DD	?
num_chars_read		DD	?
num_chars_to_read	DD	1024
read_buffer			DB	1024	DUP(00h)
write_buffer		DB	1024	DUP(00h)

	program_start_message DB "This version of the program calculates the fibinacci sequence with a recursive function call (Assembly Assignment 3)", 0ah, "Type any number to get the fibonacci value (n starts with 0:1, 1:1, 2:2, etc.) > ", 00h
fibonacci_start_msg_1 DB "To calculate ", 00h
fibonacci_start_msg_2 DB " in the fibonacci sequence", 0ah, 00h

fibonacci_process_1 DB " + ", 00h
fibonacci_process_2 DB " = ", 00h

end_message DB "The final answer is ", 00h

debug DB "debug message", 0ah, 00h
newline DB 0ah, 00h

.code

; This keeps me from going insane, I know that this is in the same file, but I think it's
; ok for this assignment

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

; useful: eax ecx edx
;         ebx ebp esp esi edi

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

fibrecurse PROC near
	; calling convention
    push	ebp         ; save old base pointer
    mov		ebp,	esp ; set stack frame base pointer

	push	ebx ; save ebx

	; function body
	mov		ebx,	[ebp + 8] ; argument - number to calculate
	cmp		ebx,	1
	jle		_recursion_end

	sub		ebx,	1
	push	ebx
	call	fibrecurse
	add		esp,	4
	push	eax

	sub		ebx,	1
	push	ebx
	call	fibrecurse
	add		esp,	4
	pop		edx
	add		eax,	edx

	pop		ebx ; restore ebx
	pop		ebp ; restore base pointer
	ret

_recursion_end:
	mov		eax,	1
	pop		ebx ; restore ebx
	pop		ebp ; restore base pointer
	ret
fibrecurse ENDP

main PROC near
_main:
	; Get stdin file handle
	push	-10
	call	_GetStdHandle@4
	mov		in_handle, eax

	; Get stdout file handle
	push	-11
	call	_GetStdHandle@4
	mov		out_handle, eax

	push offset program_start_message
	call PrintLine

	; NOTE: I went a little bit overkill here, if you want to use eax instead of stdio replace
	; from below this comment to the next comment ...

	; ReadConsole
	push	0
	push	offset num_chars_read
	push	num_chars_to_read
	push	offset read_buffer
	push	in_handle
	call	_ReadConsoleA@20

	; parse number, returns to eax
	push	offset read_buffer
	push	num_chars_read
	call	ParseNumber

	; NOTE: ... with a `mov eax, (some number to take the factorial of)`
	mov		ebx,	eax

	push	eax
	call	FmtNumber
	mov		edi,	eax

	push offset fibonacci_start_msg_1
	call PrintLine
	push edi
	call PrintLine
	push offset fibonacci_start_msg_2
	call PrintLine

	; have the parsed number in ebx
	push	ebx
	call	fibrecurse
	mov		edi,	eax

	push	offset end_message
	call	PrintLine

	push	edi
	call	FmtNumber
	push	eax
	call	PrintLine

	push	offset newline
	call	PrintLine

	; to make sure i completed the assignment correctly (even with the extra printing stuff)
	; mov result to eax
	mov		eax,	edi

	; exit with code 0
	push	0
	call	_ExitProcess@4
main ENDP
END
