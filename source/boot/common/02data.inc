; *****************************************************************************
; *****************************************************************************
;
;		Name:		data.inc
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Data allocation
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;							   Zero Page Variables
;
; *****************************************************************************

		* = ZeroPageStart

codePtr:.fill 		3 						; code ptr - extra byte for paging.

tempShort:.fill 	1 						; used for v.short term saving.

temp0:	.fill 		2
temp1:	.fill 		2
temp2:	.fill 		2
temp3:	.fill 		2
temp4:	.fill 		2

StackPtr:.fill 		2						; highest byte allocated, stack works down.

LowMemory:.fill 	2 						; next byte available working up

; *****************************************************************************
;
;								Evaluation Stack
;
; *****************************************************************************

		* = DataStackStart

esType:	.fill 		DataStackSize 			; bit 7 any reference, bit 6 byte reference, bit 0 string.									
esInt0:	.fill 		DataStackSize		 	; 32 bit integer, also used for string address
esInt1:	.fill 		DataStackSize			; (16 bit only)
esInt2:	.fill 		DataStackSize		
esInt3:	.fill 		DataStackSize		

esStrLow = esInt0 							; String address synonym
esStrHigh = esInt1 

; *****************************************************************************
;
;								Other variables
;
; *****************************************************************************

		* = DataStart
		.align 	256  						; these two must be on one page.
		
RootVariables: 								; variables A-Z which are fixed.			
		.fill 	26*4 						

HashTable:									; variable hash table.
		.fill 	HashTableSize*2 			
	
Seed32:										; random number
		.fill 	4 							

Buffer:	 									; string conversion buffer.
		.fill 	20 		

ClockTicks: 								; clock ticks.
		.fill 	4		

IToSCount:									; characters output.s
		.fill 	1		

ChrBuffer: 									; buffer for CHR()
		.fill 	2		

PrintCRFlag:								; tracks printing new line at end of PRINT
		.fill 	1
				
ArrayEnabled:	 							; when clear, cannot do array indexing.	
		.fill 	1 				

ProcTable:									; procedure list			
		.fill 	2		

ParamCount:									; # parameters evaluated in call.
		.fill 	1		

VariableAutoCreate:							; when clear, cannot autocreate variables.
		.fill 	1

AsmToken: 									; constructed assembler token.	
		.fill 	2

AsmMode:									; possible addressing modes
		.fill 	1
		
AsmOpcode: 									; base opcode
		.fill 	1		

AsmType:									; type byte (see assembleer.txt)
		.fill 	1
				
aVariable = ('A'-'A')*4+RootVariables		
oVariable = ('O'-'A')*4+RootVariables		
pVariable = ('P'-'A')*4+RootVariables		
xVariable = ('X'-'A')*4+RootVariables		
yVariable = ('Y'-'A')*4+RootVariables		
