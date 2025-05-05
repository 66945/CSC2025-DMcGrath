.386P

.model flat

extern	_ExitProcess@4:		near
extern	_GetStdHandle@4:	near
extern	_WriteConsoleA@20:	near
extern	_ReadConsoleA@20:	near

.data
in_handle	DD	?
out_handle	DD	?

msg					DB "What was that about inputing characters?", 0ah, 00h
num_chars_written	DD ?

.code
; uses the null character to terminate printing a string
; @arg str: the string to print
print_normal PROC near
	push	ebp
	mov		ebp, esp
	and		esp, 0fffffff0h

	; TODO: load in parameters

	; hold address of chars_written in ecx
	mov		esp, ecx
	push	0

	; TODO: "strlen" approximation
_strlen_loop:

	; WriteConsole
	push	0
	push	ecx
	push	35
	push	offset errmsg
	push	out_handle
	call	_WriteConsoleA@20
print_normal ENDP

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

	; exit with code 0
	push	0
	call	_ExitProcess@4
main ENDP
END
