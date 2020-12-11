1  t1 = timer
20 LET k=0 
30 LET k=k+1
40 LET a=k/2*3+4-5
45 GOSUB 700
46 FOR l=1 TO 5
48 NEXT l
50 IF k<10000 THEN GOTO 30
51 print (timer-t1)*2*5/6:end
700 RETURN