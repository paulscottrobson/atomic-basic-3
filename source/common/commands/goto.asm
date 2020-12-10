; *****************************************************************************
; *****************************************************************************
;
;		Name:		goto.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Goto
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;									GOTO
;
; *****************************************************************************

Command_Goto: 	;; [goto]
		jsr 	EvaluateBaseDeRef			; get the target line #
GotoTOS:		
		jsr 	FindGoto
		bcc 	GotoError 					; not found
		lda		temp0 						; copy new line address
		sta 	codePtr
		lda 	temp0+1
		sta 	codePtr+1
		ldy 	#3 							; first token.
		rts

GotoError:
		report 	LineNumber

; *****************************************************************************
;
;		 Find line number on stack , return CS if found, CC if not found.
;
; *****************************************************************************

FindGoto:
		set16 	temp0,BasicProgram 			; back to the start.
_FGLoop:
		ldy 	#0 							; look at link
		lda 	(temp0),y
		clc
		beq 	_FGExit
		iny 								; compare line.low
		lda 	(temp0),y
		cmp 	esInt0,x
		bne 	_FGNext
		iny 								; compare line.high
		lda 	(temp0),y
		cmp 	esInt1,x
		bne 	_FGNext
		sec
_FGExit:		
		rts

_FGNext:
		ldy 	#0
		clc
		lda 	(temp0),y
		adc 	temp0
		sta 	temp0
		bcc 	_FGLoop
		inc 	temp0+1
		jmp 	_FGLoop

