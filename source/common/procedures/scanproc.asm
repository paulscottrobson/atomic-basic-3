; *****************************************************************************
; *****************************************************************************
;
;		Name:		scanproc.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		7 Dec 2020
;		Purpose:	Scan for procedures.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;					Scan for procedures and build the table
;
; *****************************************************************************

BuildProcedureList:
		lda 	LowMemory 					; starts at low memory
		sta 	ProcTable
		lda 	LowMemory+1
		sta 	ProcTable+1
		;
		set16 	codePtr,BasicProgram 		; codePtr points to the actual code.
		;
_BPLLoop:
		ldy 	#0 							; check at the end ?
		lda 	(codePtr),y
		beq	 	_BPLExit
		ldy 	#3 							; look at first token.
		lda 	(codePtr),y
		cmp 	#KWD_PROC					; if it is PROC
		bne 	_BPLNext
		jsr 	CacheProcedure 				; cache it.
		;
_BPLNext:		
		ldy 	#0 							; next line.
		lda 	(codePtr),y
		clc
		adc 	codePtr
		sta 	codePtr
		bcc 	_BPLLoop
		inc 	codePtr+1
		jmp 	_BPLLoop

_BPLExit:		
		lda 	#0 							; write the trailing zero.
		jsr 	CacheWrite
		rts

; *****************************************************************************
;
;							Cache procedure at codePtr
;
; *****************************************************************************

CacheProcedure:
		lda 	LowMemory 					; push current position on the stack.
		pha
		lda 	LowMemory+1
		pha
		;
		;		Start off with a dummy offset
		;
		lda 	#0
		jsr 	CacheWrite
		;
		;		Calculate the hash of the line, which is a simple sum.
		;
		ldx 	#0 							; total
		ldy 	#3 	 						; after the 'PROC'-1
_CPCalculateHash:
		iny 								; next
		txa 								; add to count.
		clc
		adc 	(codePtr),y
		tax		
		lda 	(codePtr),y 					; end of name (e.g. $00-$2F)
		cmp 	#$30
		bcs 	_CPCalculateHash
		;
		pshy 								; save end of name position
		txa
		jsr 	CacheWrite 					; write the hash out.
		;
		lda 	codePtr 					; write code position of line out in lo/high
		jsr 	CacheWrite
		lda 	codePtr+1
		jsr 	cacheWrite
		;
		;		Find where the code ends.
		;
		puly  								; restore and point to next token.
		iny
		jsr 	CheckLeftParen 				; should be a (
		pshy 								; save it again.
_CPScanEnd:
		lda 	(codePtr),y 				; look for ) or EOL or :
		iny		
		cmp 	#KWD_RPAREN
		beq 	_CPScanFoundR
		cmp 	#KWD_COLON
		beq		_CPSyntax
		cmp 	#$80
		bne 	_CPScanEnd 					; no, go round.
_CPSyntax:
		report 	Syntax
		;
_CPScanFoundR:		
		tya 								; put as element 4, offset to the code
		jsr 	CacheWrite
		puly 								; restore Y position at parameter start.
		;
		;		Look for parameters loop.
		;
		lda 	(codePtr),y 				; found ) ending the list
		cmp 	#KWD_RPAREN
		beq 	_CPRExit
		;	
_CPRParameterLoop:	
		ldx 	#0 							; get localised term (in local.asm)
		jsr 	GetLocalTerm 			
		lda 	esInt1,x 					; write the address out HIGH first.
		jsr 	CacheWrite
		lda 	esInt0,x
		jsr 	CacheWrite
		;
		lda 	(codePtr),y 				; comma go back.
		iny
		cmp 	#KWD_COMMA
		beq 	_CPRParameterLoop
		cmp 	#KWD_RPAREN 				; SN error if not )
		bne 	_CPSyntax
		;
_CPRExit:
		lda 	#0 							; write trailing zero to parameter address list.
		jsr 	CacheWrite
		pla 								; pull start off to codePtr.
		sta 	temp1+1
		pla
		sta 	temp1
		;
		ldy 	#0 							; calculate current - start
		sec
		lda 	LowMemory
		sbc 	temp1
		sta 	(temp1),y 					; write it out and exit
		rts

; *****************************************************************************
;
;							Write A to cache, uses Temp1
;
; *****************************************************************************

CacheWrite:
		sty 	tempShort	
		ldy 	#0
		sta 	(LowMemory),y
		inc 	LowMemory
		bne 	_CWSkip
		inc 	LowMemory+1
_CWSkip:		
		ldy 	tempShort
		rts

		