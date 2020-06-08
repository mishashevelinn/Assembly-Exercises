.MODEL     SMALL

.STACK     64


.DATA
arr1 dw 12, 23,12, 5, 43, 15
arr2 dw 42, 23, 16, 34, 23
num1 dw 5
num2 dw 23
len1 dw 6
len2 dw 5
ten dw 10
message1 db "Number not found", 0AH, '$'
message2 db "The index of the number in array is ", '$'

; ------------------------------------------------------------------

.CODE

start:
mov     ax,@DATA
mov     ds,ax

;-----------------------------------------MAIN-----------------------------------------------------------------
main proc
push offset arr1 ;sending parameters to procedure by pushing to stack
push num1
push len1

call find				

mov ah, 02	;printing carrege return
mov dl, 0AH
int 21H

push offset arr2		;same thing but sending other parameters (of second array)
push num2
push len2

call find
endp main


jmp fin


;----------------------------------------FINDS---GIVEN---NUMBER---IN---ARRAY---------------------------------------------------
find		proc
		push bp			;standart procedure actions: setting base pointer to the last element, pushed to the stack
		mov bp, sp
		add bp, 2

		push bx			;pushing all the registers in for further proper usage
		push si
		push cx 
		push dx

		mov cx, [bp+2]		;len1 strored in ax
		mov bx, [bp+4]		;num1 strored in bx	
		mov si, [bp+6]		;pointer to arr1 stored in si


		iterate:					
			cmp bx, [si]		;compare each element of array with num1
			je founded			;jump if there is one
			add si, 2				;if not, point by si to the next element of array.  since arr1 and arr2 are arrays of words, the step is two bytes
		loop iterate
			
		mov ah, 09				;if loop is finished, there is no num1/2 in array
		lea dx, message1		;so printing the message	
		int 21H
				
		xor ax, ax					;mooving 1 to ax as required 
		mov ax, 1
		jmp quit						;and jumping to the end of procidure
					
		founded:						;we get here if num is in array
		lea dx, message2		;printing confirming message
		mov ah, 09
		int 21H
		
		mov ax, si					;as required, mooving the address to ax					
		div ten						;split HEX number into bytes -mbs - quatient--lsb - reminder
		add dx, '0'					;shifting the result to 30H to get the ASCII of number
		mov ah, 02				;print the reminder 
		int 21H
		mov si, ax					;in case ax was nullified by division command
		
		quit:
		pop dx						;pop every registers, pushed
		pop cx
		pop si
		pop bx
		pop bp
		
		ret 6							;since we work with words - size of 3 variables, pushed in main is six

		
endp find

	
fin:
;----------------end---code------------------------------------------
	mov     ah,4CH
	mov     al,0
	int     21H
	END     start