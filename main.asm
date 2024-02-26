.model tiny
.code
.286
org 100h

locals @@

MAX_PASSWORD_LEN    equ 255
CORRECT_PASSWORD	equ 22a1h

Start:
		jmp Main

;----------------------------------------------------
; Generate hash of string
; Entry:	
; Assumes:
; Destr:	ax, bx, si, cx

GetHash		proc

			mov bx, 5381d
			mov cl, LenPas
			xor ch, ch			; ch = 0
			xor ah, ah			; ah = 0

			mov si, offset Buffer
			add si, 2d
			
			@@loop1:
				shl bx, 5d 
				mov al, [si]
				add bx, ax
				inc si

				loop @@loop1

			ret
			endp
;----------------------------------------------------
; Read string from standart output
; Entry:   
; Assumes:
; Destr:	ax, dx, si
ReadString	proc

			mov ah, 0ah 
			mov al, MAX_PASSWORD_LEN
			mov [Buffer], al
			mov [Buffer + 1], 0

            mov dx, offset Buffer
			int 21h

			inc dx
			mov si, dx
			mov al, [si]
			mov LenPas, al
			inc dx

			xor ah, ah				; ah = 0
			add dx, ax
			mov si, dx
			mov byte ptr [si], '$'

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

			ret
			endp
;-------------------------------------------------
Main:
		call ReadString

		mov dx, offset Buffer
		add dx, 2d
		call PrintString

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

StringCorrect   db 10d, 'The password is correct. Access is allowed.', 03h, 03h, 03h, '$'
StringIncorrect db 10d, 'The password is incorrect. Access is denied.$'
Buffer          db MAX_PASSWORD_LEN dup (?)
LenPas         	db 0

end    		Start
