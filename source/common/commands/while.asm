; *****************************************************************************
; *****************************************************************************
;
;		Name:		while.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	While/Wend
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;									WHILE
;
; *****************************************************************************

Command_While: 	;; [While]
		lda 	#SMWhile 					; gosub marker allocate 4 bytes.
		jsr 	StackOpen 					; create on stack.
		dey
		jsr 	StackSavePosition 			; save position before the WHILE.
		iny
		jsr 	EvaluateBaseDeRef			; get the conditional
		jsr 	Int32Zero 	
		beq 	_CWFail
		rts
		;
_CWFail:
		jsr 	StackClose 					; close the just opened position.		
		lda 	#KWD_WEND 					; scan forward past WEND.
		tax
		jsr 	ScanForward
		rts

; *****************************************************************************
;
;									WEND
;
; *****************************************************************************

Command_Wend:	;; [wend]
		lda 	#SMWhile 					; check the stack matches
		jsr 	StackCheck
		bne 	_CWError
		jsr 	StackLoadPosition			; go back until true
		jsr 	StackClose 					; close the frame.
		rts

_CWError:report NoWhile
