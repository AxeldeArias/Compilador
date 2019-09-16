cls
c:\GnuWin32\bin\flex Lexico.l
echo "Se genero el Flex"
pause
cls
c:\GnuWin32\bin\bison -dyv Sintactico.y
echo "Se genero el Sintactico"
pause
cls
echo "Compilacion en curso"
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o Primera.exe
pause
Primera.exe Prueba.txt
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del Primera.exe
pause
