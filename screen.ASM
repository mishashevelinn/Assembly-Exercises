.MODEL SMALL
.STACK	64
.DATA
msg db "Good Luck$"


.CODE
start proc
mov ax, cs

mov ds, ax

mov ax, @data

mov ax, es

mov ah, 09

lea dx, msg

int 21H

mov ah, 4ch

int 21H

endp
