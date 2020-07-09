; Question 4 
; 334013844 
                      

.MODEL     SMALL

.STACK     64

; ------------------------------------------------------------------

.DATA

string db 20, ?, 20 dup ('A')
; ------------------------------------------------------------------
.CODE
main PROC

mov ax, @data
mov ds, ax


mov ah, 10
lea dx, string
int 21H

mov cl, [string +1]
inc cx

mov  si, offset string+1
mov [si], byte ptr 0ah 




push si
push ds
push cx
call print




mov ah, 4ch
int 21H
endp

print proc
	push bp
	mov bp, sp
	add bp, 2
	
	push ax
	push cx
	push si
	push dx
	push es
	
	
	mov es, [bp+4]
	mov cx, [bp+2]
	mov si, [bp+6]
	mov ah, 02
	
	
	
	
	go:
		mov dl, es: [si]
		int 21H
		inc si
	loop go
	
	pop es
	pop dx
	pop si
	pop cx
	pop ax
	pop bp
	
	ret 6
	
endp

print_code proc
	first:
	check2 db "I'm in the begining of the code"
	push si
	push ax
	
	lea si, first
	lea ax, last
	sub ax, si
	
	push si
	push cs
	push ax
	call print
	
	pop ax
	pop si
	check db "I'm in the end of the code"
	ret
	last:
	endp print_code

end main
