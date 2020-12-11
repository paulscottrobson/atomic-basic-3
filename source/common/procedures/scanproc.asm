; *****************************************************************************
; *****************************************************************************
;
;		Name:		scanproc.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		11 Dec 2020
;		Purpose:	Scan for procedures.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;					Scan for procedures and build the table
;
; *****************************************************************************

BuildProcedureList:
		lda 	LowMemory 					; starts at low memory
		sta 	ProcTable
		lda 	LowMemory+1
		sta 	ProcTable+1
		;
		set16 	temp0,BasicProgram 			; temp0 points to the actual code.
		;
_BPLLoop:
		ldy 	#0 
		lda 	(temp0),y 					; reached then end ?
		beq 	_BPLExit
		ldy 	#3 							; look to see if it is PROC
		lda 	(temp0),y
		cmp 	#KWD_PROC
		beq 	_BPLFoundProc
_BPLNext:
		ldy 	#0 							; next line.
		clc
		lda 	(temp0),y
		adc 	temp0
		sta 	temp0
		bcc 	_BPLLoop
		inc 	temp0+1
		jmp 	_BPLLoop
		;
		;		Found a procedure.
		;
_BPLFoundProc:
		lda 	#0 							; for calculating the hash.
		sta 	temp1
		ldy 	#4	
_BPLCalcHash:
		clc 								; add the tokens making the identifier to make an 8 bit hash.
		lda 	temp1
		adc 	(temp0),y
		sta 	temp1
		lda 	(temp0),y
		iny
		cmp		#$30
		bcs 	_BPLCalcHash		
		lda 	(temp0),y 					; check for (
		cmp 	#KWD_LPAREN
		bne 	BPSyntax
		iny 								; first char after (
		;
		;		Add record to table.
		;
_BPLAddRecord:
		lda 	temp0 						; write address of line (+0,+1)
		jsr 	WriteBPL
		lda 	temp0+1
		jsr 	WriteBPL
		lda 	temp1 						; write out sum hash (+2)
		jsr 	WriteBPL
		tya 								; offset to first character of parameter (+3)
		jsr 	WriteBPL
		jmp 	_BPLNext
		;		
_BPLExit:		
		lda 	#0 							; write two zeros indicating end.
		jsr 	WriteBPL
		jsr 	WriteBPL
		rts
;
;		Add a byte to the table.
;
WriteBPL:
		sty 	tempShort
		ldy 	#0
		sta 	(LowMemory),y
		inc 	LowMemory
		bne 	_WBPLExit
		inc 	LowMemory+1
_WBPLExit:		
		ldy 	tempShort
		rts

BPSyntax:
		report 	Syntax
