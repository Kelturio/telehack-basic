   10  DIM FILES$(10)
   11  FILEI% = 0
   12  MAXFILES% = 0
  100  PRINT "tar archiver 0.6a by archer" + CHR$(10)
  110  PRINT "Enter filenames and leave a blank line when done"
  120  INPUT "Filename?", TMP$
  130  IF TMP$ <> "" THEN FILES$(FILEI%) = TMP$ : FILEI% = FILEI% + 1 : GOTO 120
  135  MAXFILES% = FILEI%
  140  OPEN "test.tar", AS #5
  150  FILEI% = 0
  315  PRINT# 5, H$; FC$; PAD$;
  998  CSUM$ = STRING$(8, CHR$(32))
  999  CSINIT% = 0
 1000  REM START
 1020  F1$ = LEFT$(FILES$(FILEI%) + STRING$(100, CHR$(0)), 100)
 1030  F2$ = "0000664" + CHR$(0)
 1040  F3$ =  "0001750" + CHR$(0)
 1050  F4$ =  "0001750" + CHR$(0)
 1055  GOSUB 20000
 1060  F5$ = RIGHT$(STRING$(11, "0") + FSIZE$, 11) + CHR$(0)
 1070  F6$ = RIGHT$(STRING$(11, "0") + "03577571360", 11) + CHR$(0)
 1080  F7$ = CSUM$
 1090  F8$ = "0"
 1100  F9$ = STRING$(100, CHR$(0))
 1110  F10$ = "ustar  " + CHR$(0)
 1120  F11$ = LEFT$(USER$ + STRING$(31, CHR$(0)), 31) + CHR$(0)
 1130  F12$ = LEFT$(USER$ + STRING$(31, CHR$(0)), 31) + CHR$(0)
 1140  F13$ = STRING$(8, CHR$(0))
 1150  F14$ = STRING$(8, CHR$(0))
 1160  F15$ = STRING$(167, CHR$(0))
 1170  HS% = LEN(F1$+F2$+F3$+F4$+F5$+F6$+F7$+F8$+F9$+F10$+F11$+F12$+F13$+F14$+F15$)
 1180  H$ = F1$+F2$+F3$+F4$+F5$+F6$+F7$+F8$+F9$+F10$+F11$+F12$+F13$+F14$+F15$
 1190  FC$ = ""
 1200  OPEN FILES$(FILEI%), AS #1
 1210  IF EOF(1) = -1 THEN GOTO 1250
 1220  INPUT# 1, FILEBUF$
 1230  FC$ = FC$ + FILEBUF$ + CHR$(10)
 1240  GOTO 1210
 1250  FC$ = LEFT$(FC$, LEN(FC$)-1)
 1255  CLOSE #1
 1260  FS% = LEN(FC$)
 1281  IF CSINIT% = 0 THEN GOSUB 10000
 1290  IF CSINIT% = 0 THEN CSINIT% = 1 : GOTO 1000
 1300  PRINT "Added File "; FILES$(FILEI%); " to archive"
 1310  FILEI% = FILEI% + 1
 1311  GOSUB 10000
 1312  GOSUB 30000
 1315  PRINT# 5, H$ + FC$ + PAD$;
 1318  CSINIT% = 0 : CSUM$ = STRING$(8, CHR$(32))
 1320  IF FILEI% < MAXFILES% THEN GOTO 1000
 1330  GOSUB 5000
 1340  PRINT# 5, PAD$;
 1350  CLOSE #5
 1360  PRINT "done."
 1370  END
 5000  REM END PADDING OF 20 BLOCKS
 5001  PAD$ = ""
 5010  PAD$ = PAD$ + CHR$(0)
 5020  PS% = LEN(PAD$) + FS% + HS%
 5030  IF PS% / 512 <> 20 THEN GOTO 5010
 5040  RETURN
10000  REM SUB CALCULATE CHECKSUM
10001  SUM% = 0
10010  FOR I% = 0 TO 512
10020  SUM% = SUM% + (&HFF AND ASC(MID$(H$, I%, 1)))
10030  NEXT I%
10040  CSUM$ = RIGHT$(STRING$(6, "0") + OCT$(SUM%), 6) + CHR$(0) + CHR$(32)
10050  RETURN
20000  REM GET FILE SIZE
20005  FSIZE% = 0
20010  OPEN FILES$(FILEI%), AS #2
20020  IF EOF(2) = -1 THEN GOTO 20060
20030  INPUT# 2, TMPBUF$
20040  FSIZE% = FSIZE% + LEN(TMPBUF$)
20050  GOTO 20020
20060  CLOSE #2
20070  FSIZE$ = OCT$(FSIZE%)
20080  RETURN
30000  REM SUB END PADDING FOR RECORD
30001  REM todo check padding
30010  TT% = HS% + FSIZE% + 512
30020  TR% = TT% MOD 512
30030  IF TR% <> 0 THEN TT% = TT% - 1 : GOTO 30020
30040  PAD$ = STRING$(TT% - HS% - FS%, CHR$(0))
30045  PAD$ = LEFT$(PAD$, LEN(PAD$)-1)
30050  RETURN
