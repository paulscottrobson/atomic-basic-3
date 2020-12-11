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
		set16 	temp0,BasicProgram 			; temp0 points to the actual code.
		;
		rts
		