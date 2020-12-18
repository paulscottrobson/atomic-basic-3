; *****************************************************************************
; *****************************************************************************
;
;		Name:		asmutils.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		17 Dec 2020
;		Purpose:	Assembler support functions.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;						Write out instruction A mode X
;
; *****************************************************************************

AssemblerWrite:
		pha 								; save A
		lda 	pVariable+1 				; print address
		jsr 	AWPrintHex
		lda 	pVariable
		jsr 	AWPrintHexSpace
		pla 								; restore opcode
		jsr 	AWWriteOpcode 				; write opcode out.
		;
		lda 	AWSizeTable,x 				; get the number of bytes to output.
		tax 								; count in X		
		cmp 	#2 							; check zero mode ?
		bne 	_AWWNoCheckZP
		lda 	ESInt1 						; if zero mode, must be 00-FF
		bne 	_AWWOperand
_AWWNoCheckZP:		
		dex 							
		beq 	_AWExit
		lda 	ESInt0 					
		jsr 	AWWriteOpcode
		dex
		beq 	_AWExit
		lda 	ESInt1
		jsr 	AWWriteOpcode
_AWExit:
		jmp 	XTPrintCR		

_AWWOperand:
		report 	Operand

; *****************************************************************************
;
;						Write a single byte opcode
;
; *****************************************************************************

AWWriteOpcode:
		pha 								; save opcode
		lda 	pVariable 					; copy address in P to temp0
		sta 	temp0
		lda 	pVariable+1
		sta 	temp0+1
		sty 	tempShort 					; write byte out.
		pla
		ldy 	#0
		sta 	(temp0),y
		ldy 	tempShort
		;
		inc 	pVariable 					; bump P
		bne 	_AWWOSkip
		inc 	pVariable+1
_AWWOSkip:		
		jmp 	AWPrintHexSpace 			; write it out.

;
;		Size in bytes of opcodes for each type.
;

AWSizeTable:
		.byte 	2,2,1,3,2,2,3,3
		.byte 	3,3,2,2,2,2 	

; *****************************************************************************
;
;
; *****************************************************************************

AWPrintHexSpace:
		jsr 	AWPrintHex
		lda 	#' '
		jmp 	XTPrintA		
AWPrintHex:
		pha
		lsr 	a
		lsr 	a
		lsr 	a
		lsr 	a
		jsr 	_AWPrintNibble
		pla
_AWPrintNibble:
		and 	#$0F
		cmp 	#10
		bcc 	_AWNotHex
		adc 	#6
_AWNotHex:
		adc 	#48
		jmp 	XTPrintA				
