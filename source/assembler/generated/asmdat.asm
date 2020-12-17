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
	.word $2261 ; bit
	.byte $24
	.byte $f0

	.word $3448 ; inc
	.byte $1a
	.byte $f2

	.word $1043 ; dec
	.byte $3a
	.byte $f2

	.word $440e ; ora
	.byte $01
	.byte $01

AndMnemonic:
	.word $3460 ; and
	.byte $21
	.byte $01

	.word $3a24 ; eor
	.byte $41
	.byte $01

	.word $4c12 ; sta
	.byte $61
	.byte $01

	.word $0c0b ; lda
	.byte $81
	.byte $01

	.word $31e2 ; cmp
	.byte $a1
	.byte $01

	.word $0452 ; sbc
	.byte $e1
	.byte $01

	.word $4960 ; asl
	.byte $02
	.byte $12

	.word $3971 ; rol
	.byte $22
	.byte $12

	.word $4a2b ; lsr
	.byte $42
	.byte $12

	.word $3a31 ; ror
	.byte $62
	.byte $12

	.word $4ef2 ; stx
	.byte $82
	.byte $22

	.word $0eeb ; ldx
	.byte $a2
	.byte $32

	.word $1043 ; dec
	.byte $c2
	.byte $42

	.word $3448 ; inc
	.byte $e2
	.byte $42

	.word $2261 ; bit
	.byte $20
	.byte $43

	.word $4f12 ; sty
	.byte $80
	.byte $23

	.word $0f0b ; ldy
	.byte $a0
	.byte $53

	.word $3f02 ; cpy
	.byte $c0
	.byte $63

	.word $3ee2 ; cpx
	.byte $e0
	.byte $63

	.word $3d61 ; bpl
	.byte $10
	.byte $fa

	.word $3101 ; bmi
	.byte $30
	.byte $fa

	.word $5441 ; bvc
	.byte $50
	.byte $fa

	.word $0a41 ; bcs
	.byte $70
	.byte $fa

	.word $0841 ; bcc
	.byte $90
	.byte $fa

	.word $0a41 ; bcs
	.byte $b0
	.byte $fa

	.word $3481 ; bne
	.byte $d0
	.byte $fa

	.word $1201 ; beq
	.byte $f0
	.byte $fa

	.word $4a29 ; jsr
	.byte $20
	.byte $f3

	.word $31e9 ; jmp
	.byte $4c
	.byte $f3

	.word $31e9 ; jmp
	.byte $6c
	.byte $f9

	.word $4541 ; brk
	.byte $00
	.byte $f2

	.word $4d11 ; rti
	.byte $40
	.byte $f2

	.word $4e51 ; rts
	.byte $60
	.byte $f2

	.word $1def ; php
	.byte $08
	.byte $f2

	.word $2def ; plp
	.byte $28
	.byte $f2

	.word $1c0f ; pha
	.byte $48
	.byte $f2

	.word $2c0f ; pla
	.byte $68
	.byte $f2

	.word $1303 ; dey
	.byte $88
	.byte $f2

	.word $0313 ; tay
	.byte $a8
	.byte $f2

	.word $3708 ; iny
	.byte $c8
	.byte $f2

	.word $36e8 ; inx
	.byte $e8
	.byte $f2

	.word $2c42 ; clc
	.byte $18
	.byte $f2

	.word $1052 ; sec
	.byte $38
	.byte $f2

	.word $2d02 ; cli
	.byte $58
	.byte $f2

	.word $1112 ; sei
	.byte $78
	.byte $f2

	.word $6013 ; tya
	.byte $98
	.byte $f2

	.word $2ea2 ; clv
	.byte $b8
	.byte $f2

	.word $2c62 ; cld
	.byte $d8
	.byte $f2

	.word $1072 ; sed
	.byte $f8
	.byte $f2

	.word $5c13 ; txa
	.byte $8a
	.byte $f2

	.word $5e53 ; txs
	.byte $9a
	.byte $f2

	.word $02f3 ; tax
	.byte $aa
	.byte $f2

	.word $4af3 ; tsx
	.byte $ba
	.byte $f2

	.word $12e3 ; dex
	.byte $ca
	.byte $f2

	.word $39ed ; nop
	.byte $ea
	.byte $f2

	.word $31e9 ; jmp
	.byte $7c
	.byte $f8

	.word $4401 ; bra
	.byte $80
	.byte $fa

	.word $4f32 ; stz
	.byte $64
	.byte $f1

	.word $4f32 ; stz
	.byte $9c
	.byte $f3

	.word $4f32 ; stz
	.byte $74
	.byte $f5

	.word $4f32 ; stz
	.byte $9e
	.byte $f7

	.word $1f0f ; phy
	.byte $5a
	.byte $f2

	.word $2f0f ; ply
	.byte $7a
	.byte $f2

	.word $1eef ; phx
	.byte $da
	.byte $f2

	.word $1f0f ; phy
	.byte $fa
	.byte $f2

	.word $FFFF
