.model tiny
.286
.code
org 100h

locals @@

MAX_PASSWORD_LEN    equ 8d
CORRECT_PASSWORD	equ 22a1h
END_STR				equ 0dh


Start:
		jmp Main
		
StringCorrect   db 10d, 'The password is correct. Access is allowed.', 03h, 03h, 03h, '$'
StringIncorrect db 10d, 'The password is incorrect. Access is denied.$'
Buffer          db MAX_PASSWORD_LEN dup (?)

;----------------------------------------------------
Main:
		call ReadString
		call GetHash

		cmp bx, CORRECT_PASSWORD
		je @@cor
			mov dx, offset StringIncorrect
			jmp @@continue

		@@cor:
			mov dx, offset StringCorrect

		@@continue:

		call PrintString
		call ExitProg
;----------------------------------------------------
; Generate hash of string
; Entry:	
; Assumes:
; Destr:	ax, bx, si

GetHash		proc

			mov bx, 5381d
			xor ah, ah			; ah = 0

			mov si, offset Buffer
			mov al, [si]

			@@loop1:
				shl bx, 5d 
				add bx, ax

				inc si
				mov al, [si]

				cmp al, END_STR
				jne @@loop1

			ret
			endp
;----------------------------------------------------
; Read string from standart output
; Entry:   
; Assumes:
; Destr:	ax, si
ReadString	proc

			xor al, al 				; al = 0
			mov ah, 01h 
			mov si, offset Buffer
			
			@@loop1:
				int 21h
				cmp al, END_STR
				je @@continue

				mov byte ptr [si], al
				inc si
				jmp @@loop1

			@@continue:
				mov byte ptr [si], al

			ret
			endp
;----------------------------------------------------
; Print string to standart output
; Entry:    dx - offset to string
; Assumes:
; Destr:	ah

PrintString	proc

			mov ah, 09h 
			int 21h

			ret
			endp
;----------------------------------------------------
; Exit of programm
; Entry:
; Assumes:
; Destr:	ax

ExitProg	proc

			mov ax,  4c00h
			int 21h

			endp
;-------------------------------------------------

end    		Start
