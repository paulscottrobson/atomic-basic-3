; *****************************************************************************
; *****************************************************************************
;
;		Name:		vdu.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	VDU Command
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								Vdu command
;
; *****************************************************************************

Command_Vdu:	;; [vdu]
		jsr 	EvaluateBaseDeRef			; evaluate the thing being asserted.
		lda 	esInt0,x 					; get the byte
		jsr 	XTPrintA 					; and print it
		;
		lda 	(codePtr),y 				; if comma follows
		iny
		cmp 	#KWD_COMMA
		beq 	Command_Vdu 				; loop back roun.
		dey
		rts