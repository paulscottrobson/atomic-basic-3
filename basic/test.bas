mem = alloc(25)
print &mem,mem
mem!0 = 42
mem!4 = -2
mem!8 = &12345678
print &mem!8,mem!4,mem!0
print &mem(2),mem(1),mem(0)
mem(2) = &AA55AA55
print &mem!8,mem!4,mem!0
print &mem(2),mem(1),mem(0)

