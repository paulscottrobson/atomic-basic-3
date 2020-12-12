n1 = 81:n2 = 92:n3 = 103
xx = 42:d = -1
call prc1(-4,"Hello",D)
call prc2()
print xx,d
print n1,n2,n3
stop
proc prc1(n1,n2,n3)
	call prc3()
	print "PRC1",xx,n1,n2,n3
	call prc3()
endproc

proc prc2()
	print "PRC2",xx
endproc

proc prc3()
	local xx:xx = 12
	print "PRC3",xx
endproc