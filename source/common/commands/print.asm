; *****************************************************************************
; *****************************************************************************
;
;		Name:		print.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Print
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;									PRINT
;
; *****************************************************************************

Command_Print: 	;; [print]

_CPRLoop:
		lda 	#0 							; zero the print CRFlag
_CPRSetFlag:
		sta 	PrintCRFlag
		lda 	(codePtr),y 				; look at token.
		cmp 	#$80						; if EOL exit.		
		beq 	_CPRExit 					
		cmp 	#KWD_COLON 					; if colon exit
		beq 	_CPRExit
		;
		cmp 	#$60 						; if $60  it is a string.
		beq 	_CPRString
		;
		cmp 	#$00 						; if -ve go to token
		bmi 	_CPRToken
		cmp 	#$70 						; is it a number, if so print as decimal.
		bcs 	_CPRDecimal
_CPRToken:
		lda 	(codePtr),y 				; get the token ID and skip it.
		iny
		;
		cmp 	#KWD_SEMICOLON 				; semicolon goes to set flag which is now non zero
		beq 	_CPRSetFlag
		cmp 	#KWD_SQUOTE 				; single quote is CR.
		beq 	_CPRNewLine
		cmp 	#KWD_AMPERSAND 				; &x means print in hex
		beq 	_CPRHexaDecimal
		cmp 	#KWD_COMMA 					; comma is tab (possibly space)
		beq 	_CPRTab
		;
		dey 								; undo the skip.
		;
		;		Print decimal
		;
_CPRDecimal:
		lda 	#10+128
		bne 	_CPRPrintInteger
		;
		;		Print hex
		;
_CPRHexaDecimal:
		lda 	#16
		bne 	_CPRPrintInteger
		;
		;		Print String (expression)
		;
_CPRStringExpr:
		pla 								; chuck the base.
		pshx
		pshy
		ldy 	esInt0,x
		lda 	esInt1,x
		tax
		jsr 	PrintXYString
		puly
		pulx
		jmp 	_CPRLoop		
		;
		;		Print String (quotes)
		;
_CPRString:
		iny 								; move to start of string. 					
		iny		
_CPRStringLoop:
		lda 	(codePtr),y 				; get next character and bump
		iny
		cmp 	#0 							; end of string, loop back.
		beq 	_CPRLoop		
		jsr 	XTPrintA 					; print it and try next character.
		jmp 	_CPRStringLoop
		;
		;		Print CR
		;
_CPRNewLine:
		jsr 	XTPrintCR
		jmp 	_CPRLoop		
		;
		;		Print Tab (,) blocks new line.
		;
_CPRTab:
		jsr 	XTPrintTab
		lda 	#1
		jmp 	_CPRSetFlag
		;
		;		Exit, checking if we print CR. (if printCrFlag is zero)
		;
_CPRExit:
		lda 	PrintCRFlag 				; check flag.
		bne 	_CPRNoNL
		jsr 	XTPrintCR	
_CPRNoNL:	
		rts		
		;
		;		Print integer.
		;
_CPRPrintInteger:
		pha 								; save base on stack
		jsr 	EvaluateBaseDeref 			; evaluate whatever it is.
		lda 	esType,x 					; is it a string expression ?
		lsr 	a
		bcs 	_CPRStringExpr
		set16 	temp0,buffer 				; set up for buffer
		pla
		jsr 	Int32ToString 				; convert in the buffer.
		pshx 								; print the buffer.
		ldx 	#0  						
_CPROutBuffer:
		lda 	buffer,x
		beq 	_CPROBExit
		jsr 	XTPrintA
		inx
		bne 	_CPROutBuffer
_CPROBExit:				
		pulx
		jmp 	_CPRLoop

