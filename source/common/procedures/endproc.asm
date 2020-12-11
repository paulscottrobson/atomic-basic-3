; *****************************************************************************
; *****************************************************************************
;
;		Name:		endproc.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		11 Dec 2020
;		Purpose:	Return from procedure
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;									ENDPROC
;
; ****************************************************************************

Command_EndProc:	;; [endproc]
		jsr 	StackPopLocals 				; restore local variables.
		lda 	#SMProcedure				; check TOS is PROC
		jsr 	StackCheck
		bne 	_EPError
		jsr 	StackLoadPosition 			; restore position and drop
		jsr 	StackClose
		rts
_EPError:
		report 	NoProc
