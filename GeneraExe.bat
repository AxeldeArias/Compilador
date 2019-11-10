z:\GnuWin32\bin\flex Lexico.l
pause
z:\GnuWin32\bin\bison -dyv Sintactico.y
pause
<<<<<<< Updated upstream
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o Primera.exe
pause
Primera Prueba.txt
=======
cls
echo "Compilacion en curso"
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o Segunda.exe
pause
Segunda.exe Prueba.txt
>>>>>>> Stashed changes
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del Segunda.exe
pause
