; *****************************************************************************
; *****************************************************************************
;
;		Name:		scanproc.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		11 Dec 2020
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
		lda 	#0 							; first link is zero
		sta 	ProcList
		sta 	ProcList+1
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
		jsr 	ScanParameters 				; find the parameters
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
		rts

; *****************************************************************************
;
;			Scan for parameters, which are stored in the buffer.
;		  (done seperately because it is likely to create variables)
;
; *****************************************************************************

ScanParameters:
		pshy 								; save Y
		lda 	#1
		sta 	Buffer 						; 'next free' in the buffer, start recording at Buffer+1
		;
		;		Look for opening left bracket.
		;
_SPFindOpen:
		lda 	(codePtr),y					; get next
		iny 
		cmp 	#KWD_LPAREN 				; ( token ?
		bne 	_SPFindOpen 				
		;
		;		Now extract the parameters.
		;
_SPGrabParams:
		lda 	(codePtr),y 				; found ) ?
		cmp 	#KWD_RPAREN 	
		beq 	_SPExit
		;
		ldx 	#0 							; start on stack
		lda 	#7  						; get a term
		jsr 	EvaluateLevelAX 			; this is the variable/parameter to localise.
		;
		lda 	esType,x 					; which should be a reference of some sort
		bpl 	SPSyntax 					; if not, syntax error.
		;
		ldx 	Buffer 						; write into Buffer in Hi-Lo order.
		lda		esInt1
		sta 	Buffer,x
		lda		esInt0
		sta 	Buffer+1,x
		inx
		inx
		stx 	Buffer
		lda 	(codePtr),y 				; found , ?
		iny
		cmp 	#KWD_COMMA 					; if so, get next.
		beq 	_SPGrabParams 				
		cmp 	#KWD_RPAREN 				; if not )
		bne 	SPSyntax					; syntax error.
_SPExit:
		puly
		rts
SPSyntax:
		report 	Syntax

; *****************************************************************************
;
;							Cache procedure at codePtr
;
; *****************************************************************************


CacheProcedure:
		lda 	LowMemory 					; push low memory (current addr) on the stack
		pha
		lda 	LowMemory+1
		pha
		;
		lda 	ProcList 					; write out the previous entry
		jsr 	CacheWrite
		lda 	ProcList+1
		jsr 	CacheWrite
		;
		pla 								; write this one out as the current head of the linked procedure list.
		sta 	ProcList+1
		pla
		sta 	ProcList
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
		lda 	(codePtr),y 				; end of name (e.g. $00-$2F)
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
_CPScanEnd:
		lda 	(codePtr),y 				; look for ) or EOL or :
		iny		
		cmp 	#KWD_COLON
		beq		SPSyntax
		cmp 	#$80
		beq 	SPSyntax
		cmp 	#KWD_RPAREN
		bne 	_CPScanEnd
		;
_CPScanFoundR:		
		tya 								; put as element 4, offset to the code
		jsr 	CacheWrite
		ldx 	#0 							; copy the buffer out.
_CPCopyBuffer:
		cpx 	Buffer
		beq 	_CPDoneCopy
		lda 	Buffer+1,x
		jsr 	CacheWrite
		inx
		jmp 	_CPCopyBuffer
		;
_CPDoneCopy:
		lda 	#0 							; write trailing zero to parameter address list.
		jsr 	CacheWrite
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

		