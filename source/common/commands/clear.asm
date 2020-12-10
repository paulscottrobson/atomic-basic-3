; *****************************************************************************
; *****************************************************************************
;
;		Name:		clear.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Clear all variables.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;						Find end of program in temp0
;
; *****************************************************************************

FindEnd:
		set16	temp0,BasicProgram 			; start ... at the start.
		pshy
_FELoop:ldy 	#0 							; look at offset
		lda 	(temp0),y
		beq 	_FEExit 					; end if zero
		;
		clc 								; add to position.
		adc 	temp0
		sta 	temp0
		bcc 	_FELoop
		inc 	temp0+1
		jmp 	_FELoop

_FEExit:puly		
		rts

; *****************************************************************************
;
;				Clear non A-Z variables and the hash table
;
; *****************************************************************************

CommandClear:	;; [clear]
		pshx
		jsr 	FindEnd 					; find end of memory
		inc 	temp0 						; add 1, first free byte
		bne 	_CCSkip
		inc 	temp0+1
_CCSkip:lda 	temp0 						; copy into low memory
		sta 	LowMemory
		lda 	temp0+1
		sta 	LowMemory+1
		set16 	StackPtr,EndMemory 			; reset stack pointer.
		;
		ldx 	#0 							; blank hash table
		txa
_CCErase:
		sta 	HashTable,x
		inx
		cpx 	#HashTableSize*2
		bne 	_CCErase
		pulx
		rts		
