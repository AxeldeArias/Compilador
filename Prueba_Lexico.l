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
ID				{LETRA}({LETRA}|{DIGITO}|_)*
COMENTARIO  	"--/".*"/--"


CTE_E		(-?)([1-9])({DIGITO})*
CTE_R		(-?)([1-9])*"."({DIGITO})*
CTE_S 		\"([^(\")])*\"

%%
"REPEAT"		{ return C_REPEAT_A; }
"UNTIL"			{ return C_REPEAT_C; }
"IF"			{ return C_IF_A; }
"ELSE"			{ return C_IF_E; }
"ENDIF"			{ return C_IF_C; }

"FILTER"		{ return C_FILTER_A; }
"ENDFILTER"		{ return C_FILTER_C; }

"PRINT"			{ return PRINT; }
"READ"			{ return READ; }


"VAR"			{ return VAR; }
"ENDVAR"		{ return ENDVAR; }
"CONST"			{ return CONST; }
"Integer"		{ return INTEGER; }
"Float"			{ return FLOAT; }
"String"		{ return STRING; }


"="			{ return OP_ASIG;}
"+"			{ return OP_SUMARESTA;}
"-"			{ return OP_SUMARESTA;}
"*"			{ return OP_MULDIV;}
"/"			{ return OP_MULDIV;}

"("			{ return PARENTESIS_A;}
")"			{ return PARENTESIS_C;}
"{"			{ return LLAVE_A;}
"}"			{ return LLAVE_C;}
"["			{ return CORCHETE_A; }
"]"			{ return CORCHETE_C; }
","			{ return COMA; }
";"			{ return PYC; }
":"			{ return DOSPUNTOS; }
"_"			{ return GUIONBAJO; }

"=="		{ return OP_IGUAL;}
"!=="		{ return OP_DISTINTO;}
"<"			{ return OP_COMPARACION;}
"<="		{ return OP_COMPARACION;}
">"			{ return OP_COMPARACION;}
">="		{ return OP_COMPARACION;}
"AND"		{ return OP_LOGICO;}
"OR"		{ return OP_LOGICO;}
"!"		{ return OP_NEGACION; }

{ID}			{ return ID;}
{CTE_E}			{ yylval = atoi( yytext ) ;return CTE_E;}
{CTE_R}			{ yylval = atof( yytext ) ;return CTE_R;}
{CTE_S}			{ return CTE_S;}
{COMENTARIO}	/* IGNORAR TOKEN */
[\t\n]+			/* IGNORAR TOKEN */

"\n"      		
"\t"		



