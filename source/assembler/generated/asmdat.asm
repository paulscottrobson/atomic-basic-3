;
;	Automatically Generated
;
MaskTable:
	.byte $ff ; Mask $0x
	.byte $75 ; Mask $1x
	.byte $54 ; Mask $2x
	.byte $d5 ; Mask $3x
	.byte $55 ; Mask $4x
	.byte $d4 ; Mask $5x
	.byte $d0 ; Mask $6x

OpcodeTable:
	.word $2033 ; bit
	.byte $24
	.byte $f0

	.word $3502 ; inc
	.byte $1a
	.byte $f2

	.word $1062 ; dec
	.byte $3a
	.byte $f2

	.word $45c0 ; ora
	.byte $01
	.byte $01

AndMnemonic:
	.word $3403 ; and
	.byte $21
	.byte $01

	.word $3891 ; eor
	.byte $41
	.byte $01

	.word $4e40 ; sta
	.byte $61
	.byte $01

	.word $0d60 ; lda
	.byte $81
	.byte $01

	.word $304f ; cmp
	.byte $a1
	.byte $01

	.word $0642 ; sbc
	.byte $e1
	.byte $01

	.word $480b ; asl
	.byte $02
	.byte $12

	.word $3a2b ; rol
	.byte $22
	.byte $12

	.word $4971 ; lsr
	.byte $42
	.byte $12

	.word $3a31 ; ror
	.byte $62
	.byte $12

	.word $4e57 ; stx
	.byte $82
	.byte $22

	.word $0d77 ; ldx
	.byte $a2
	.byte $32

	.word $1062 ; dec
	.byte $c2
	.byte $42

	.word $3502 ; inc
	.byte $e2
	.byte $42

	.word $2033 ; bit
	.byte $20
	.byte $43

	.word $4e58 ; sty
	.byte $80
	.byte $23

	.word $0d78 ; ldy
	.byte $a0
	.byte $53

	.word $3c58 ; cpy
	.byte $c0
	.byte $63

	.word $3c57 ; cpx
	.byte $e0
	.byte $63

	.word $3c2b ; bpl
	.byte $10
	.byte $fa

	.word $3028 ; bmi
	.byte $30
	.byte $fa

	.word $5422 ; bvc
	.byte $50
	.byte $fa

	.word $0832 ; bcs
	.byte $70
	.byte $fa

	.word $0822 ; bcc
	.byte $90
	.byte $fa

	.word $0832 ; bcs
	.byte $b0
	.byte $fa

	.word $3424 ; bne
	.byte $d0
	.byte $fa

	.word $1030 ; beq
	.byte $f0
	.byte $fa

	.word $4931 ; jsr
	.byte $20
	.byte $f3

	.word $312f ; jmp
	.byte $4c
	.byte $f3

	.word $312f ; jmp
	.byte $6c
	.byte $f9

	.word $442a ; brk
	.byte $00
	.byte $f2

	.word $4e28 ; rti
	.byte $40
	.byte $f2

	.word $4e32 ; rts
	.byte $60
	.byte $f2

	.word $1def ; php
	.byte $08
	.byte $f2

	.word $2def ; plp
	.byte $28
	.byte $f2

	.word $1de0 ; pha
	.byte $48
	.byte $f2

	.word $2de0 ; pla
	.byte $68
	.byte $f2

	.word $1078 ; dey
	.byte $88
	.byte $f2

	.word $0278 ; tay
	.byte $a8
	.byte $f2

	.word $3518 ; iny
	.byte $c8
	.byte $f2

	.word $3517 ; inx
	.byte $e8
	.byte $f2

	.word $2c42 ; clc
	.byte $18
	.byte $f2

	.word $1242 ; sec
	.byte $38
	.byte $f2

	.word $2c48 ; cli
	.byte $58
	.byte $f2

	.word $1248 ; sei
	.byte $78
	.byte $f2

	.word $6260 ; tya
	.byte $98
	.byte $f2

	.word $2c55 ; clv
	.byte $b8
	.byte $f2

	.word $2c43 ; cld
	.byte $d8
	.byte $f2

	.word $1243 ; sed
	.byte $f8
	.byte $f2

	.word $5e60 ; txa
	.byte $8a
	.byte $f2

	.word $5e72 ; txs
	.byte $9a
	.byte $f2

	.word $0277 ; tax
	.byte $aa
	.byte $f2

	.word $4a77 ; tsx
	.byte $ba
	.byte $f2

	.word $1077 ; dex
	.byte $ca
	.byte $f2

	.word $39af ; nop
	.byte $ea
	.byte $f2

	.word $312f ; jmp
	.byte $7c
	.byte $f8

	.word $4420 ; bra
	.byte $80
	.byte $fa

	.word $4e59 ; stz
	.byte $64
	.byte $f1

	.word $4e59 ; stz
	.byte $9c
	.byte $f3

	.word $4e59 ; stz
	.byte $74
	.byte $f5

	.word $4e59 ; stz
	.byte $9e
	.byte $f7

	.word $1df8 ; phy
	.byte $5a
	.byte $f2

	.word $2df8 ; ply
	.byte $7a
	.byte $f2

	.word $1df7 ; phx
	.byte $da
	.byte $f2

	.word $1df8 ; phy
	.byte $fa
	.byte $f2

	.word $FFFF
