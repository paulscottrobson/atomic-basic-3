; *****************************************************************************
; *****************************************************************************
;
;		Name:		gosub.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Gosub & Return
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;									GOSUB
;
; *****************************************************************************

Command_Gosub: 	;; [gosub]
		jsr 	EvaluateBaseDeRef			; get the target line #
		lda 	#SMGosub 					; gosub marker allocate 4 bytes.
		jsr 	StackOpen 					; create on stack.
		jsr 	StackSavePosition 			; save position.
		jmp 	GotoTOS 					; and use the GOTO code.

; *****************************************************************************
;
;									RETURN
;
; *****************************************************************************

Command_Return:	;; [return]
		lda 	#SMGosub 					; check the stack matches
		jsr 	StackCheck
		bne 	_RTError
		jsr 	StackLoadPosition 			; load the position back
		jsr 	StackClose 					; close the frame.
		rts

_RTError:report NoGosub		
