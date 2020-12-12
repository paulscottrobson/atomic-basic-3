xx = 42
call prc1()
call prc2()
print xx
stop
proc prc1()
	call prc3()
	print "PRC1",xx
	call prc3()
endproc

proc prc2()
	print "PRC2",xx
endproc

proc prc3()
	local xx:print xx:xx = 12
	print "PRC3",xx
endproc