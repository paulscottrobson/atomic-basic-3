; *****************************************************************************
; *****************************************************************************
;
;		Name:		rem.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Comment handler.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								Rem Command
;
; *****************************************************************************

Command_Rem:	;; [rem]
Command_Rem2:	;; [']
		lda 	(codePtr),y 				; should be followed by string
		cmp 	#$60
		bne 	_CRMExit
		tya
		iny
		clc
		adc 	(codePtr),y
		tay
_CRMExit:		
		rts

