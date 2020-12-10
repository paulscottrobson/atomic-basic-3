; *****************************************************************************
; *****************************************************************************
;
;		Name:		stack.inc
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Stack constants
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;			Markers, set in the top 4 bits, count in lower 4 bits
;
; *****************************************************************************

SMGosub = $14 								; gosub marker (4 bytes, marker + position)
SMRepeat = $24 								; repeat marker (4 bytes, marker + position)
SMWhile = $34 								; while marker (4 bytes, marker + position)
SMFor = $4B 								; for marker (11 bytes, see for.asm)
SMProcedure = $54 							; procedure marker (4 bytes, marker + position)
SMLocal = $67 								; local marker (7 bytes, marker, address, data)

StackSizeMask = $0F 						; converts marker to bytes required.

