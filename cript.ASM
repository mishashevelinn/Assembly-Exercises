;encription 
.MODEL SMALL
.STACK	64
.DATA
abc		db	"abcdefghijklmnopqrstuvwxyz", '$'
cripto db 		"thequickbrownfxjmpsvalzydg", '$'
msg db "this is easy!",'$'
var db ?


.CODE
main PROC

	mov	ax, @data                                                                                                                                                              		
	mov	ds, ax



	lea si, msg
	mov cx, offset var - offset msg
	push si
	push cx

	call encript

	mov ah, 4ch
	int 21H
	
ENDP main

encript PROC
	
	push bp
	mov bp, sp
	add bp, 2
	
	push si
	push cx
	push ax
	push dx

	mov si, [bp+4]
	mov cx, [bp+2]
	xor ax, ax
	
	
	go:
		mov al, [si]
		push ax
		call get_script
		mov [si], dl
		inc si
	loop go
	
	mov ah, 09
	mov dx, offset msg
	int 21H
	
	pop dx
	pop ax
	pop cx
	pop si
	pop bp
	ret 4
ENDP encript

get_script proc

	push bp
	mov bp, sp
	add bp, 2
	
	push si
	push cx
	push ax
	
	lea si, abc
	mov cx, offset msg - offset cripto
	mov ax, [bp+2]
	push si
	push cx
	push ax
	call find
	
	cmp ax, -1
	je quit
		
	add ax, offset cripto
	mov si, ax
	mov dl, [si]
	jmp fin
	
	quit:
	mov dl, [bp+2]
	
	fin:
	pop ax
	pop cx
	pop si
	pop bp
	ret 2
	
endp get_script
	
find proc 

	push bp
	mov bp, sp
	add bp, 2
	
	push si
	push bx
	push cx
	
	mov si, [bp+6]
	mov cx, [bp+4]
	mov bx, [bp+2]
	

	search:
	cmp [si], bl
	je return
	inc si
	loop search
	jmp fail
	
	return:
	;sub si, offset msg
	mov ax, si
	jmp exit
	
	fail:
	mov ax, -1
	jmp exit
	
	exit:
	pop cx
	pop bx
	pop si
	pop bp
	ret 6
	
endp 	find 
	

END main

