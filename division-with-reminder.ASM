;Question 3
;334013844


.MODEL     SMALL

.STACK     64


.DATA
str1  db 6,?,6 dup(?)  ;two string arrays for user's input
str2  db 6,?,6 dup(?)
num1 dw 0				;two numbers to store converted input
num2 dw 0
ten dw 1					;for ten's powers, used in convertion
temp dw 0					; to store inbetween arithmetical actions results
whole dw 0					;thwo variables to store the results
modul dw 0
whole_str db 6 dup(?), '$'		;two strings to store results in ASCII for print out
modul_str db 6 dup(?), '$'
msg db "Whole Part Is: $"					;Helping messages
msg2 db "The Reminder Is: $"
msg3 db "The Reminder Is: 0$"


; ------------------------------------------------------------------

.CODE

start:
	mov     ax,@DATA
	mov     ds,ax
;-----------------------------------------------------------------------------------------------code start--------------------------------------------------------------------------------------------------------

;--------------------------main---------------------------------------
;Main Procidure Calls to converters(to and from ASCII, HEX)
;previously setting pointers each times 
;to different variables. 
call input

lea si, str1 			;pointing with si each time to another string
mov cl, [str1+1]	;and calling to converter procedure
add  si, cx
inc si
;-------------------
call str_to_num
mov num1, ax		;str_to_num ends by storing the result in ax so moving it to result variable
;------------------------------------
lea si, str2
mov cl, [str2+1]
add  si, cx
inc si
;-------------------
call str_to_num
mov num2, ax

call compare		;calling copmersion procidure, wich also swaps 
							;between variables, if needed

call division			;devision procidure after convert


lea dx, msg         ;prints helper messege
mov ah, 09
int 21H

mov [ten], 10   ;preparing to call print function
xor ax, ax
mov ax, 1
xor dx, dx
mov ax, whole
lea si, whole_str+5
call print

;-----------------------------------zero-reminder-case------------------------------
cmp modul, 0
je zero

lea dx, msg2		
mov ah, 09
int 21H
;-----------------------------preparing-to-call-print--for-the-next-number-------
lea si, modul_str+5
xor ax, ax
mov ax, 1
xor dx, dx
mov ax, modul
call print
jmp fin
;-------------prints messege if reminder is zero----------------------------
zero:
lea dx, msg3
mov ah, 09
int 21H


jmp fin
;-----------------------input---------------------------------------------------------------------------
;procidure witch responsible to ger users input and print Carrege return--------------
input		proc
		push cx
		xor cx, cx
		mov cx, 2  ;desined in loop, occures two times
		
		lea dx, str1
		get_num:
			mov ah, 0AH
			int 21H
			jmp CR
	

		CR:
			mov ah,02
			mov dl, 0AH
			int 21H
			dec cx
			cmp cx, 0
			je return
			lea dx, str2
			jmp get_num
				
		return:
		pop cx
		ret
endp input
;--------------------------------string-to-number-convertion-------------------------------
str_to_num proc
	xor ax, ax
	xor dx, dx
	
	mov ax, 1

	convert:			
		mov bl, [si]		;substract 30H to get actual number from ASCII
		sub bl, 30H
		mov ax, word ptr ten			
		mul bx					;multiply it by increasing powers of ten
		add temp, ax		;starting from LSB
		mov ax, 10			;and add result to temporary variable
		mul ten
		mov  [ten], ax
		dec si
		xor ax, ax
	loop convert

	mov ax, word ptr temp	;then store temporary variable to ax for further transport to result variable
	mov temp, 0000H
	mov ten, 0001H

ret
endp str_to_num

;--------------------------------compare-two-numbers-and-swap-if-needed-----------------------------
compare proc
		xor ax, ax
		mov ax, num1
		cmp ax, num2 ;if first number less than second
		jl swap
		jmp endproc
		swap:
		xchg ax, num2 			;we swap them in memory
		mov num1, ax			;since xchg can't get two memory references, using 
		endproc:					;ax as assisting container 
		ret
endp compare



division proc
	xor dx, dx					;actual devision after convertion
	xor ax, ax						
	mov ax, num1			
	div num2
	mov whole, ax				;storing the results in variables
	mov modul, dx
	
ret
endp division

;--------------------------------------print results---------------------------------------
;does reverse process 
print proc

	translate:
	cmp ax, 0			
	je quit		
		div ten				;each time devide by tento get last HEX digit
		add dx, 30H		;add to it 30 to get its ASCII
		mov [si], dl		;and lace it in the end of string array, whitch si points to
		xor dx, dx
		dec si
		
		jmp translate
quit:	
mov dx, si			;as si decreased to the beginning of string, point to it by dx
mov ah, 09			;then print the result
int 21H

mov ah,02			;print Carrege return
xor dh, dh
mov dl, 0AH
int 21H

ret
endp print

	
;----------------------------------------end of program-----------------------
fin:
;----------------end---code------------------------------------------
	mov     ah,4CH
	mov     al,0
	int     21H
	END     start