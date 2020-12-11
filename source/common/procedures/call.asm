; *****************************************************************************
; *****************************************************************************
;
;		Name:		call.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		11 Dec 2020
;		Purpose:	Invoke procedure.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;							CALL <name> (<params>)
;
; *****************************************************************************

Command_Call:	;; [call]
		stop
		;
		sec 								; put into temp1 the address of the identifier (so we can use ,Y)
		tya 
		adc 	codePtr
		sta 	temp1
		lda 	codePtr+1
		adc		#0
		sta 	temp1+1
		;
		ldx 	#0 							; calculate the hash, in X
_CalcHash:
		txa
		clc
		adc 	(codePtr),y		
		tax
		lda 	(codePtr),y
		iny
		cmp 	#$30
		bcs 	_CalcHash 
		;
		jsr 	CheckLeftParen 				; check for opening bracket.
		pshy 								; save parameters star on stack.
		;
		;		Now find the procedure to call in temp0
		;
		set16 	temp0,
