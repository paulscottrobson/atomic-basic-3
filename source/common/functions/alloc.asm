; *****************************************************************************
; *****************************************************************************
;
;		Name:		alloc.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Allocate memory.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								ALLOC command
;
; *****************************************************************************

Unary_Alloc:	;; [alloc]
		report NotImplemented
;		jsr 	EvaluateTerm				; memory to allocate
;		;
;		lda 	LowMemory 					; push low memory ons tack.
;		pha
;		lda 	LowMemory+1
;		pha
;		;
;		jsr 	AllocMemStackCount 			; allocate memory (in DIM code)
;		;
;		pla 								; update stack entry
;		sta 	esInt1,x
;		pla
;		sta 	esInt0,x
;		lda 	#0
;		sta 	esInt2,x
;		sta 	esInt3,x
;		sta 	esType,x
;		rts


