.386P

.model flat

PrintLine   PROTO
ParseNumber PROTO
FmtNumber   PROTO

extern	_ExitProcess@4:		near
extern	_GetStdHandle@4:	near
extern	_WriteConsoleA@20:	near
extern	_ReadConsoleA@20:	near

.data
public in_handle
public out_handle
public num_chars_written
public num_chars_read
public num_chars_to_read
public read_buffer
public write_buffer

in_handle			DD	?
out_handle			DD	?
num_chars_written	DD	?
num_chars_read		DD	?
num_chars_to_read	DD	1024
read_buffer			DB	1024	DUP(00h)
write_buffer		DB	1024	DUP(00h)

program_start_message DB "Multiply numbers together >", 00h

end_message DB "The final answer is ", 00h

debug DB "debug message", 0ah, 00h
newline DB 0ah, 00h

.code

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

	mov		ebx,	eax

	push offset newline
	call PrintLine

	push offset program_start_message
	call PrintLine

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

	imul	ebx,	eax
	push	ebx
	call	FmtNumber
	mov		edi,	eax

	push	offset end_message
	call	PrintLine
	push	edi
	call	PrintLine

	; exit with code 0
	push	0
	call	_ExitProcess@4
main ENDP
END
