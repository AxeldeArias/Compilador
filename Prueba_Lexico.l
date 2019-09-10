%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
FILE  *yyin;
int yylval;

%}
%option noyywrap  
%option yylineno 

DIGITO			[0-9]
LETRA			[a-zA-Z]
ID			{LETRA}({LETRA}|{DIGITO}|_)*
COMENTARIO  (--\/).*(\/--)

%%
"="			{ return ASIG;}
"+"			{ return OP_SUMA;}
"-"			{ return OP_RESTA;}
"*"			{ return OP_MUL;}
"/"			{ return OP_DIV;}
"("			{ return P_A;}
")"			{ return P_C;}
"{"			{ return L_A;}
"}"			{ return L_C;}
"=="			{ return OP_I;}
"!=="			{ return OP_D;}
"<"			{ return OP_MEN;}
"<="		{ return OP_MEN_IG;}
">"			{ return OP_MAY;}
">="		{ return OP_MAY_IG;}


"IF"			{ return IF;}
"ELSE"			{ return ELSE;}
"AND"			{ return AND;}
"OR"			{ return OR;}
{ID}			{ return ID;}
{DIGITO}+	      { yylval = atoi( yytext ) ;return CTE_E;}
({DIGITO}+"."{DIGITO}*|{DIGITO}*"."{DIGITO}+) { yylval = atof( yytext ) ;return CTE_R;}
\"([\\"])*\" { return CTE_S;}

{COMENTARIO} {return COMENTARIO;};
"\n"      		
"\t"		



