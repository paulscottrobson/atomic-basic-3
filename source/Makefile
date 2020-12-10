ifeq ($(OS),Windows_NT)
CCOPY = copy
CCOPYQ = >NUL
CMAKE = mingw32-make
DEL = del /Q
DELQ = 2>NUL
S = \\
else
CCOPY = cp
CCOPYQ = 
CMAKE = make
DEL = rm -f
DELQ = 
S = /
endif

.PHONY : all

BASDIR = ..$(S)basic$(S)

BASIC = $(BASDIR)test.bas
SCRIPTS = ..$(S)scripts$(S)
GENERATOR = makepgm.py

BUILD = boot.x16 boot.common extern.x16 interface.test common testing.simple
all : asm.out$(S)basic.prg

run : asm.out$(S)basic.prg
	..$(S)bin$(S)x16emu -prg asm.out$(S)basic.prg -scale 2 -run -debug

testing$(S)simple$(S)02testcode.asm : $(SCRIPTS)tokenworker.py
	python $(SCRIPTS)tokenworker.py

testing$(S)code$(S)99program.asm : $(SCRIPTS)$(GENERATOR)
		python $(SCRIPTS)$(GENERATOR) $(BASIC)

DEPS = 	$(wildcard **/*.asm) $(wildcard **/*.inc) \
		$(wildcard *.asm) $(wildcard *.inc) \
		$(SCRIPTS)errors.py $(SCRIPTS)tokentables.py \
		testing$(S)simple$(S)02testcode.asm \
		testing$(S)code$(S)99program.asm
		
asm.out$(S)basic.prg : $(DEPS) 
#	python $(SCRIPTS)genvartest.py >$(BASIC)
	python $(SCRIPTS)errors.py
	python $(SCRIPTS)tokentables.py
	python $(SCRIPTS)builder.py $(BUILD)
	$(DEL) *.bin $(DELQ)
	64tass -q --m65xx basic.asm -L asm.out$(S)basic.lst -l asm.out$(S)basic.lbl -o asm.out$(S)basic.prg