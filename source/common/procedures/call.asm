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
		clc
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
		pshx 								; save Hash on stack.
		jsr 	CheckLeftParen 				; check for opening parameter bracket.
		;
		;		Evaluate all the procedures on successive stack levels.
		;
		ldx 	#0 							; actually start at 1 with pre-increment.
_CCEvaluateParameters:
		lda 	(codePtr),y 				; hit )
		cmp 	#KWD_RPAREN
		beq 	_CCHaveParams
		inx 								; first parameter goes in offset #1.
		report 	NotImplemented 				; evaluate parameters on stack

_CCHaveParams:		
		;
		;		Scan through the procedure table looking for a match.
		;
		pla 								; put the hash into temp2
		sta 	temp2
		pshy 								; save the RParen position on the stack

		lda 	ProcTable 					; copy ProcTable to temp0
		sta 	temp0
		lda 	ProcTable+1
		sta 	temp0+1
_CCCheckLoop:
		ldy 	#1 							; check the MSB of the line entry, if zero, then not found.
		lda 	(temp0),y 		
		beq 	_CCNoProc
		sta 	temp3+1 					; save in temp3+1
		iny 								; get the hash
		lda 	(temp0),y 					
		cmp 	temp2 						; does it match ?
		bne 	_CCNext
		ldy 	#0 							; get LSB into temp3
		lda 	(temp0),y
		sta 	temp3
		;
		ldy 	#3 							; start offset 4 pre-increment.
_CCCompare:
		iny 								; check match
		lda 	(temp3),y
		cmp 	(temp1),y
		bne 	_CCNext		
		cmp 	#$30 						; stop if reached actual match.
		bcs 	_CCCompare
		bcc 	_CCFound 					; yes, a match.
_CCNext:
		clc 								; go four on, table size.
		lda 	temp0
		adc 	#4
		sta 	temp0
		bcc 	_CCCheckLoop		
		inc 	temp0+1
		jmp 	_CCCheckLoop
		;
		;		Push the return address on the stack.
		;
_CCFound:
		puly 								; get the offset of the ) back
		iny 								; now point to the token after it
		lda 	#SMProcedure				; open a procedure frame
		jsr 	StackOpen
		jsr 	StackSavePosition 			; save return address on the stack.
		;
		ldy 	#3 							; get the offset to the start of the parameter list
		lda 	(temp0),y
		tay
		lda 	temp3 						; copy start of line into code Ptr
		sta 	codePtr
		lda		temp3+1
		sta 	codePtr+1
		;
		;		Go through the parameters localising each one and copying the new value in.		
		;
_CCSaveParams:		
		lda 	(codePtr),y 				; found the right bracket
		cmp 	#KWD_RPAREN
		beq 	_CCExit

		report 	NotImplemented


_CCExit:
		iny 								; skip the right bracket
		rts

_CCNoProc:
		report 	BadProc		

