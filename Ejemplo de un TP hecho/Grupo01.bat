flex Lexico.l
bison -dyv Sintactico.y
pause
c:\MinGW\bin\gcc lex.yy.c y.tab.c -lfl -o Grupo01
pause
Grupo01.exe prueba.txt
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
pause
