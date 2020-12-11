; *****************************************************************************
; *****************************************************************************
;
;		Name:		varsearch.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		11 Dec 2020
;		Purpose:	Find variable (not A-Z)
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;			Search for variable as set up in variables.asm. If found
;			return base address in temp0 and CS, else CC.
;
; *****************************************************************************

VariableSearch:	
		lda 	temp1 						; put the first hash link address into temp0
		sta 	temp0
		lda 	temp1+1
		sta 	temp0+1
_VSLoop:		
		ldy 	#1 							; look at MSB of link to follow
		lda 	(temp0),y
		beq 	_VSFail						; if zero, end of linked list, so exit with CC
		tax 								; follow the link.
		dey
		lda 	(temp0),y
		sta 	temp0
		stx 	temp0+1
		;
		ldy 	#2 							; check the hashes match
		lda 	(temp0),y
		cmp 	temp2 						; no, they don't, go around.
		bne 	_VSLoop
		;
		iny 								; copy the varname address into temp4
		lda 	(temp0),y
		sta 	temp4
		iny
		lda 	(temp0),y
		sta 	temp4+1
		;
		ldy 	#0 							; now compare them.
_VSCompareName:
		lda 	(temp4),y
		cmp 	(temp3),y
		bne 	_VSLoop 					; different, go around
		iny
		cmp 	#$30 						; reached end marker
		bcs 	_VSCompareName
		sec 								; and we match.
		rts

_VSFail:clc		
		rts
		