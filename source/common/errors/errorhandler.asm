; *****************************************************************************
; *****************************************************************************
;
;		Name:		errorhandler.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Error Handler
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;							Generic error handler.
;
; *****************************************************************************

ErrorHandler:
		sty 	temp3
		pla 								; line addr into XY.
		tay
		pla
		tax
		iny
		bne 	_EHNoBump
		inx
_EHNoBump:
		jsr 	PrintXYString 				; print it
		ldy 	#0 							; if offset = 0 (e.g. not in program)
		lda 	(codePtr),y
		beq 	_GoWarm 					; no line #
		jsr 	PrintSpace
		lda 	#'@'
		jsr 	XTPrintAC
		jsr 	PrintSpace
		ldx 	#0 							; set up for ITOA conversion
		iny
		lda 	(codePtr),y
		sta 	esInt0,x
		iny
		lda 	(codePtr),y
		sta 	esInt1,x
		txa		
		sta 	esInt2,x
		sta 	esInt3,x
		set16 	temp0,buffer 				; conversion buffer.
		lda 	#10 						; convert base 10.
		jsr 	Int32ToString
		ldx 	#buffer >> 8
		ldy 	#buffer & $FF
		jsr 	PrintXYString
_GoWarm:
		lda 	temp3
		jmp 	WarmStart

; *****************************************************************************
;
;							Used for undefined keywords
;
; *****************************************************************************

InstructionUndefined:
		report 	NotImplemented

; *****************************************************************************
;
;								  Helper functions
;
; *****************************************************************************

PrintSpace:
		lda 	#32
		jmp 	XTPrintAC

PrintXYString:
		pha
		sty 	temp0
		stx 	temp0+1
		ldy 	#0
_PXYSLoop:
		lda 	(temp0),y
		jsr 	XTPrintAC
		iny
		lda 	(temp0),y
		bne 	_PXYSLoop
		ldy 	temp0
		ldx 	temp0+1
		pla
		rts
