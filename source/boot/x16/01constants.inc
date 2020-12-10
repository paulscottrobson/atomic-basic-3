; *****************************************************************************
; *****************************************************************************
;
;		Name:		constants.inc
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	General Constants
;
; *****************************************************************************
; *****************************************************************************

		DataStackSize = 8
		HashTableSize = 16

		ZeroPageStart = $00
		DataStackStart = $20
		DataStart = $800					; must be on a page boundary.

		CodeBase = $1000
		EndMemory = $9E00
