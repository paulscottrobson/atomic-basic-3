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
		cmp 	#$80
		beq 	_SFNextLine 				; if $80 go to next line.
		bcs  	_SFFoundCommand				; if -ve its a token
		cmp 	#$60 						; if $60 it's a string.
		beq 	_SFSkipString
_SFNextToken:
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
		jsr 	CommandNextLine
		jmp 	_SFLoop
		;
		;		Found a command of some sort.
		;
_SFFoundCommand:
		lda 	temp2 						; structure level is non-zero then don't check
		bne 	_SFNoCheck
		lda 	(codePtr),y  				; get the token.
		cmp 	temp3 						; if it matches either, then we win.
		beq 	_SFFoundEnd
		cmp 	temp3+1
		beq 	_SFFoundEnd
_SFNoCheck:
		lda 	(codePtr),y 				; get the token
		tax 								; get its type
		lda 	KeywordTypes-$80,x
		bpl		_SFNextToken 				; not a command
		sec 
		sbc 	#$81 						; this is now -1 if close, 0 normal, 1 open.
		clc
		adc 	temp2 						; add to structure level
		sta 	temp2
		bmi		_SFBalance 			
		bpl 	_SFNextToken

_SFFoundEnd:
		iny									; skip over the token
		rts		

_SFBalance:
		report 	Closure		
		