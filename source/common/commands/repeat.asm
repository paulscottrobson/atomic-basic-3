; *****************************************************************************
; *****************************************************************************
;
;		Name:		repeat.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Repeat/Until
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;									REPEAT
;
; *****************************************************************************

Command_Repeat: 	;; [Repeat]
		lda 	#SMRepeat 					; repeat marker allocate 4 bytes.
		jsr 	StackOpen 					; create on stack.
		jsr 	StackSavePosition 			; save position.
		rts

; *****************************************************************************
;
;									UNTIL
;
; *****************************************************************************

Command_Until:	;; [until]
		lda 	#SMRepeat 					; check the stack matches
		jsr 	StackCheck
		bne 	_CUError
		jsr 	EvaluateBaseDeRef			; get the conditional
		jsr 	Int32Zero 	
		beq 	_CULoopBack
		jsr 	StackClose 					; close the frame.
		rts

_CULoopBack:
		jsr 	StackLoadPosition			; go back until true
		rts

_CUError:report NoRepeat
