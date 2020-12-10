; *****************************************************************************
; *****************************************************************************
;
;		Name:		scanner.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Scan forward to branch over groups.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;					Scan forward looking for token A or X
;
; *****************************************************************************

ScanForward:
		sta 	temp3 						; save tokens to search in temp3/temp3+1
		stx 	temp3+1
		lda 	#0 							; temp2 counts structure levels.
		sta 	temp2 					
		;
		;		Main loop
		;
_SFLoop:lda 	(codePtr),y 				; look at the high token.
		beq 	_SFNextLine 				; if $00 go to next line.
		bmi 	_SFNextToken
		cmp 	#$01 						; if $01 it's a string.
		beq 	_SFSkipString
		;
		and 	#$FC 						; is it 0001 10xx which we may need to check.
		cmp 	#$18
		beq 	_SFFoundCommand
_SFNextToken:
		iny
		iny
		jmp 	_SFLoop				
		;
		;		Inline string - advance over it.
		;
_SFSkipString:
		tya
		iny
		clc
		adc 	(codePtr),y
		tay
		jmp 	_SFLoop		
		;
		;		End of line.
		;
_SFNextLine:		
		ldy 	#0 							; use offset to go to next line.
		lda 	(codePtr),y
		clc
		adc 	codePtr
		sta 	codePtr
		bcc 	_SFNLNoCarry
		inc 	codePtr+1
_SFNLNoCarry:
		lda 	(codePtr),y					; is the offset here zero
		ldy 	#3
		cmp 	#0
		bne 	_SFLoop 					; no, then loop round with Y = 3
		report Closure 						; didn't match.		
		;
		;		Found a command of some sort.
		;
_SFFoundCommand:
		lda 	temp2 						; structure level is non-zero then don't check
		bne 	_SFNoCheck
		iny 								; get the token.
		lda 	(codePtr),y 
		dey
		cmp 	temp3 						; if it matches either, then we win.
		beq 	_SFFoundEnd
		cmp 	temp3+1
		beq 	_SFFoundEnd
_SFNoCheck:

		lda 	(codePtr),y 				; get the high byte.
		sec 
		sbc 	#$19 						; this is now -1 if close, 0 normal, 1 open.
		clc
		adc 	temp2 						; add to structure level
		sta 	temp2
		bmi		_SFBalance 			

		jmp 	_SFNextToken

_SFFoundEnd:
		iny									; skip over the token
		iny
		rts		

_SFBalance:
		report 	Closure		
		