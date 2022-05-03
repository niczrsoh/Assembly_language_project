; TITLE COA GroupProject Group 6

; AUM JEEVAN A / L AUM NIRANGKAR A20EC0017;
; SOH ZEN REN A20EC0152
; MOHAMAD HAZIQ ZIKRY BIN MOHAMMAD RAZAK A20EC0079

INCLUDE Irvine32.inc

.data
	NumberLength dword ?
	binarynum byte 9 DUP(? )
	decimalnum dword ?
	str1 byte ">>> Please select the conversion type: ", 0
	str2 byte "1. Binary to Decimal", 0
	str3 byte "2. Decimal to Binary", 0
	str4 byte "3. Exit", 0
	str5 byte "---------------------------------------", 0
	prompt byte "Enter your choice: ", 0

	; binary prompts
	binary_prompt byte "Please Enter 8-bit binary digits (e.g., 11110000) :", 0
	b2d_ans1 byte "The decimal integer of ", 0
	b2d_ans2 byte "b is ", 0

	; decimal prompts
	decimal_prompt byte "Please Enter a decimal integer less than 256: ", 0
	d2b_ans1 byte "The binary of ", 0
	d2b_ans2 byte "d is ", 0

	; exit  prompts
	exit_prompt byte "Bye.", 0

	; errormessage
	error_choice byte "ERROR.... Please select correct choice !", 0
	error_binary byte "ERROR.... Please enter 8-bit binary digits !", 0
	error_decimal byte "ERROR... Please enter decimal integer that less than 256 !", 0
	.code

; main menu

main PROC
	mainmenu :
			mov edx, offset str1
			call WriteString; Display Output Statement
			call crlf
			mov edx, offset str2
			call WriteString					; Display option 1 in main menu
			call crlf
			mov edx, offset str3
			call WriteString					; Display option 2 in main menu
			call crlf
			mov edx, offset str4
			call WriteString					; Display option 3 in main menu
			call crlf
			mov edx, offset str5
			call WriteString					; Display Output Line
			call crlf

			mov edx, offset prompt
			call WriteString; Display "Enter Your Choice"
			call ReadInt
        

		;Compare the input from user so that assembly can know which function to jump 
		CMP AX, 1
		JE Bin2Dec
		CMP AX, 2
		JE Dec2Bin
		CMP AX, 3
		JE exitprog
		JNE errormessage1

; ---------------------------------------------------- -
; JMP TO THIS ERROR IF THE INPUT CHOICE IS NOT DISCOVER
; ----------------------------------------------------
errormessage1:
	mov edx, offset error_choice
	call WriteString ;Display error_choice
	call crlf
	jmp mainmenu
; ------------------------------------------------------------
; JMP TO THIS ERROR IF THE INPUT BINARY IS NOT 8 BIT / NOT 0 & 1
; ------------------------------------------------------------
errormessage2:
	mov edx, offset error_binary
	call WriteString ;Display error_binary
	call crlf
	jmp mainmenu
; ------------------------------------------------------------ -
; JMP TO THIS ERROR IF THE INPUT DECIMAL IS NOT LESS TAHN 256
; ------------------------------------------------------------ -
errormessage3:
	mov edx, offset error_decimal
	call WriteString ;Display error_decimal
	call crlf
	jmp mainmenu

; ------------------------------------
; binary to decimal function
; ------------------------------------
Bin2Dec:
	; calling the prompt& input the binary number
	mov decimalnum, 0
	mov edx, offset binary_prompt
	call WriteString			;Display binary_prompt
	mov edx, offset binarynum
	mov ecx, SIZEOF binarynum 
	call ReadString
	cmp eax, 8d 
	jne errormessage2

; converter part
mov esi, 7
mov ecx, 8
; binarynum[0], binarynum[1], binarynum[2]....binarynum[7] -> 8bit  , so esi->7
; 8,7,6,5,4,3,2,1,(0)->jump to bin2dec_ans , so ecx->8
; both ecx & esi will decrease once finish one loop
Converter1:
	mov NumberLength, 8d
	cmp ecx, 0
	je Bin2Dec_ans
	cmp binarynum[esi], '1'
	je todosum
	cmp binarynum[esi], '0'
	je increment
	jne errormessage2
	todosum :
		sub NumberLength, ecx	; substract numberlength, 8 with the latest ecx to get the exact position
		mov eax, 1d				; move the value of eax with 1
	whilePart:
		cmp NumberLength, 0		; if numberlength is 0 then jmp to sumPart
		je sumPart
		mov ebx, 2d				; move ebx with 2
		mul ebx					; multiply eax with ebx which is 2
		dec NumberLength		; decrease the numberlength by 1
		jmp whilePart			; loop again
; if at index 4, then it should loop 4 times, 2x2x2x2 = 16 
; 2 pow 4= 16
	sumPart :
		add decimalnum, eax		; add the eax into decimalnum
		jmp increment			; jmp to increment
	increment :
		dec esi				; decrease esi
		dec ecx				; decrease ecx by 1
		jmp Converter1		; jmp back to converter1

; ANSWER OUTPUT
Bin2Dec_ans :
	mov edx, offset b2d_ans1
	call WriteString		;Display b2d_ans1
	mov edx, offset binarynum
	call WriteString		;Display binarynum
	mov edx, offset b2d_ans2
	call WriteString		;Diplay b2d_ans2
	
	mov eax, decimalnum
	call WriteDec

	mov al, 'd'
	call WriteChar
	call crlf
	call crlf

	jmp mainmenu

; ------------------------------------
; decimal to binary function
; ------------------------------------

Dec2Bin:
	mov edx, offset decimal_prompt
	call WriteString
	call ReadDec
	mov decimalnum, eax
	cmp eax, 255d
	ja errormessage3

;converter part 
		mov esi, 7
		mov eax, decimalnum
		mov ecx, 8

Converter2 :
		mov edx, 0
		mov ebx, 2d
		div ebx
		cmp edx, 1
		je makingbinary1
		cmp edx, 0
		je makingbinary0
		makingbinary1 :
		mov binarynum[esi], '1'
		jmp increment2
		makingbinary0 :
		mov binarynum[esi], '0'
		jmp increment2
		increment2 :
		dec esi
		loop Converter2

; ANSWER OUTPUT
Dec2Bin_ans :		
		mov edx, offset d2b_ans1
		call WriteString		;Display d2b_ans1
		mov eax, decimalnum
		call WriteDec		;Display decimalnum
		mov edx, offset d2b_ans2
		call WriteString		;Display d2b_ans2
		mov edx, offset binarynum
		call WriteString		;Display binarynum

		mov al, 'b'
		Call WriteChar
		call crlf
		call crlf

		jmp mainmenu

exitprog :
			mov edx, offset exit_prompt
			call WriteString	;Display Exit Prompt
			call crlf
			call WaitMsg

exit
main ENDP
end main
