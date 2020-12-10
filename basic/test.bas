' "Star triangle"
for i = 1 to 10
call line(i)
next i:stop

proc line(size):
	local i
	for i = 1 to size:print "*";:next
	print
endproc
