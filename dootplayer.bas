    1  DELAY% = 0
   10  OPEN "DOOT.VTT", AS #5
   20  SLEEP DELAY% : IF EOF(5) < 0 GOTO 200
   30  INPUT# 5, BUF$
   40  IF LEFT$(BUF$,7) = "[2J[H[H" THEN CLS : GOTO 20
   50  IF LEFT$(BUF$,2) = "[H" THEN HOME : GOTO 20
   60  PRINT BUF$
  100  GOTO 20
  200  CLOSE #5
