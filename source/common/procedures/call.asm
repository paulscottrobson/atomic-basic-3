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
		;
		;		Create a pointer y-4 back so we can compare identifiers starting
		;		from Y = 4
		;
		tya 								; Y offset - 4
		sec
		sbc 	#4
		adc 	codePtr 					; add to CodePtr -> temp1
		sta 	temp1
		lda 	codePtr+1
		adc 	#0
		sta 	temp1+1
		;
		;		Calculate the hash of the identifier.
		;
		ldx 	#0
_CCCalcHash:
		txa 								; which is simple additive
		clc
		adc 	(codePtr),y
		tax
		lda 	(codePtr),y 				; until added end marker.
		iny
		cmp 	#$30
		bcs 	_CCCalCHash		
		jsr 	CheckLeftParen 				; check for opening parameter bracket.
		;
		;		Scan through the procedure table looking for a match.
		;
		stop
		lda 	ProcTable 					; copy ProcTable to temp0
		sta 	temp0
		lda 	ProcTable+1
		sta 	temp0+1
		;
		;		Evaluate all the procedures on successive stack levels.
		;

		;
		;		Push the return address on the stack.
		;

		;
		;		Go through the parameters localising each one and copying the new value in.		
		;
		rts