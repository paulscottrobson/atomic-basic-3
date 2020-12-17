# *****************************************************************************
# *****************************************************************************
#
#		Name:		assembler.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		13 Dec 2020
#		Purpose:	Build Assembly Table
#
# *****************************************************************************
# *****************************************************************************

import re,os,sys

entries = [] 																		# Entries in order.
masks = { }																			# Opcode masks 
maskList = [] 																		# List of mask values.
group = None 																		# current group : 1,2,3,S,I

h = open(".."+os.sep+"source"+os.sep+"assembler"+os.sep+"inline"+os.sep+"generated"+os.sep+"asmdat.asm","w")

																					# load and preprocess
src = [x.strip() for x in open(".."+os.sep+"documents"+os.sep+"assembler.def").readlines() if not x.startswith(";")]
src = [x.replace("\t"," ").lower() for x in src if x != ""]

for s in src:
	if s == "[specific]" or s == "[implied]":										# decode groups
		group = s[1].upper()
	elif re.match("^\\[group\\d\\]$",s):
		group = int(s[-2])
	#
	elif group == 'S':																# S is specific address mode.
		m = re.match("^([0-9a-f]+)\\s*([a-z]+)\\s*\\((\\d+)\\)$",s)					# [hex] [opcode] ([mode])
		assert m is not None,"Group S : "+s
		op = { "opcode":int(m.group(1),16),"mnemonic":m.group(2),"mode":int(m.group(3))+0xF0 }
		entries.append(op)
	#
	elif group == 'I':																# I is implied mode.
		m = re.match("^([0-9a-f]+)\\s*([a-z]+)$",s)									# [hex] [opcode]
		assert m is not None,"Group I : "+s
		op = { "opcode":int(m.group(1),16),"mnemonic":m.group(2),"mode":0xF2 }
		entries.append(op)		
	#
	else:
		m = re.match("^([0-9a-f]+)\\s*([a-z]+)(.*)$",s)								# split into three bits.
		assert m is not None,"Group {0} : ".format(group)+s
		op = { "opcode":int(m.group(1),16),"mnemonic":m.group(2) }					# everything but the mode.
		mask = "[********]" if m.group(3) == "" else m.group(3).strip()				# default mask
		mByte = int(mask[1:-1].replace("*","1").replace("-","0"),2) 				# convert to a byte
		if mByte not in masks:														# does it exist already ?
			maskID = len(masks.keys()) 												# create a new one ?
			masks[mByte] = maskID
			maskList.append(mByte)
		op["mode"] = group + masks[mByte] * 16 										# use the mask ID and group => mode
		entries.append(op)

h.write(";\n;\tAutomatically Generated\n;\n")

h.write("MaskTable:\n")
for i in range(0,len(maskList)):
	h.write("\t.byte ${0:02x} ; Mask ${1:01x}x\n".format(maskList[i],i))
h.write("\n")
h.write("OpcodeTable:\n")
for op in entries:
	name = [ord(x) - ord('A') for x in op["mnemonic"].upper()]						# convert name to offsets from 0
	encode = (name[2] << 5)+(name[1] << 10)+name[0]									# encode in 15 bits.
	assert (encode & 0xFF) != 0xFF 													# $FF is end of list maker
	if op["mnemonic"] == "and":														# This hack because AND is tokenised.
		h.write("AndMnemonic:\n")
	h.write("\t.word ${0:04x} ; {1}\n".format(encode,op["mnemonic"])) 				# encoded mnemonic
	h.write("\t.byte ${0:02x}\n".format(op["opcode"]))								# base opcode
	h.write("\t.byte ${0:02x}\n\n".format(op["mode"]))								# decode mode.
h.write("\t.word $FFFF\n")

h.close()

