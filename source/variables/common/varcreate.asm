; *****************************************************************************
; *****************************************************************************
;
;		Name:		varcreate.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		11 Dec 2020
;		Purpose:	Create a variable
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;			Create a variable as set up by variable.asm and temp0
;			will point to its record.
;
; *****************************************************************************

VariableCreate:
		lda 	VariableAutoCreate 			; are we allowed to autocreate
		beq 	_CVNoCreate		
		;
		lda 	LowMemory 					; copy LowMemory to temp0 adding 9 as you go
		sta 	temp0 						; 9 is the size of a variable record.
		clc 
		adc 	#9
		sta 	LowMemory
		lda 	LowMemory+1
		sta 	temp0+1
		adc 	#0
		sta 	LowMemory+1
		;
		cmp 	StackPtr+1 					; caught up with high memory ?
		bcs 	_CVMemoryError
		;
		ldy 	#0 							; copy the current link from hash table into the 'next' links
		lda 	(temp1),y 					; from the hash table, inserting it into the front.
		sta 	(temp0),y 					; (offset 0 & 1)
		iny
		lda 	(temp1),y
		sta 	(temp0),y
		iny
		;
		lda 	temp2 						; write full 8 bit hash into offset 2
		sta 	(temp0),y
		iny
		;
		clc 								; write variable name address into offset 3,4 (codePtr + y)
		lda 	temp3
		sta 	(temp0),y
		iny
		lda 	temp3+1
		sta 	(temp0),y
_CVClear:									; clear the rest of the variable record. (5-8, data)
		iny
		lda 	#$00
		sta 	(temp0),y
		cpy 	#8
		bne 	_CVClear
		;
		ldy 	#0 							; put the address of the record as the new link head
		lda 	temp0
		sta 	(temp1),y
		iny
		lda 	temp0+1
		sta 	(temp1),y
		;
		rts

_CVMemoryError:
		report 	Memory		
_CVNoCreate		
		report 	UnknownVar		