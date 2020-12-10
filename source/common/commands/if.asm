; *****************************************************************************
; *****************************************************************************
;
;		Name:		if.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	IF statement
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;					IF ... THEN or IF ... ELSE ... ENDIF
;
; *****************************************************************************

Command_IF: 	;; [if]
		jsr 	EvaluateBaseDeRef			; get the target address
		lda 	(codePtr),y 				; is it followed by THEN ?
		cmp 	#KWD_THEN
		bne 	StructureIF
		;
		;		THEN - the standard BASIC THEN. (cannot do same line else for syntax reasons)
		;
		iny 								; skip THEN
		jsr 	Int32Zero 					; is it true ?
		beq 	_IfFalse
		;
		lda 	(codePtr),y 				; if THEN <const> do GOTO.
		bmi 	_CIFExit
		cmp 	#$70
		bcs 	_CIFGoto
_CIFExit:		
		rts 								; otherwise carry on.
_CIFGoto:
		jmp 	Command_GOTO			
_IfFalse:
		jmp 	CommandNextLine
		;
		;		This is the structured IF <expression> <block> [ELSE <block>] ENDIF
		;
StructureIF:
		jsr 	Int32Zero 					; is it true ?
		beq 	_SIFSkip 					; if non-zero then skip to ELSE/ENDIF
		rts 								; else continue.

_SIFSkip:
		lda	 	#KWD_ELSE 					; test failed, go to ELSE or ENDIF whichever comes first.
		ldx 	#KWD_ENDIF	
		jmp		ScanForward

;
;		Else is executed after passing a test, and skip forward to ENDIF
;
Command_ELSE:		;; [else]	
		ldx 	#KWD_ENDIF		
		txa
		jmp		ScanForward
	

;
;		ENDIF is just a No-op, it's a marker for the structure end.
;
Command_ENDIF:	;; [endif]
		rts		