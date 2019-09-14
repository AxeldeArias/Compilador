%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
FILE  *yyin;

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
"REPEAT"		{ printf("REPEAT\n"); 		return C_REPEAT_A; }
"UNTIL"			{ printf("UNTIL");			return C_REPEAT_C; }
"IF"			{ printf("IF");				return C_IF_A; }
"ELSE"			{ printf("ELSE");			return C_IF_E; }
"ENDIF"			{ printf("ENDIF");			return C_IF_C; }
	
"FILTER"		{ printf("FILTER");			return C_FILTER_A; }
"ENDFILTER"		{ printf("ENDFILTER");		return C_FILTER_C; }

"PRINT"			{ printf("PRINT");			return PRINT; }
"READ"			{ printf("READ");			return READ; }


"VAR"			{ return VAR; }
"ENDVAR"		{ return ENDVAR; }
"CONST"			{ printf("CONST"); 			return CONST; }
"Integer"		{ printf("Integer");		return INTEGER; }
"Float"			{ printf("Float");			return FLOAT; }
"String"		{ printf("String");			return STRING; }


"="			{ printf(" = ");			return OP_ASIG;}
"+"			{ printf(" + ");				return OP_SUMARESTA;}
"-"			{ printf(" - ");				return OP_SUMARESTA;}
"*"			{ printf(" * ");				return OP_MULDIV;}
"/"			{ printf(" / ");				return OP_MULDIV;}

"("			{ printf("(");				return PARENTESIS_A;}
")"			{ printf(")");				return PARENTESIS_C;}
"{"			{ printf("{\n");				return LLAVE_A;}
"}"			{ printf("}\n");				return LLAVE_C;}
"["			{ printf("[");				return CORCHETE_A; }
"]"			{ printf("]");				return CORCHETE_C; }
","			{ printf(",");				return COMA; }
";"			{ printf(";\n");			return PYC; }
":"			{ printf(":");				return DOSPUNTOS; }
"_"			{ printf("_");				return GUIONBAJO; }

"=="		{ printf(" == "); 	return OP_COMPARACION;}
"!=="		{ printf(" !== "); 	return OP_COMPARACION;}
"<"			{ printf(" < "); 	return OP_COMPARACION;}
"<="		{ printf(" <= "); 	return OP_COMPARACION;}
">"			{ printf(" > "); 	return OP_COMPARACION;}
">="		{ printf(" >= ");	return OP_COMPARACION;}
"AND"		{ printf(" AND ");	return OP_LOGICO;}
"OR"		{ printf(" OR ");	return OP_LOGICO;}
"!"			{ printf(" !");		return OP_NEGACION; }

{ID}			{ yylval.str_val = yytext; printf( "ID(%s)", yylval.str_val); return ID;}
{CTE_E}			{ yylval.intval = atoi(yytext); printf( "ENTERO(%d)", yylval.intval); return CTE_E;}
{CTE_R}			{ yylval.val = atof(yytext); printf( "FLOAT(%f)", yylval.val); return CTE_R;}
{CTE_S}			{ yylval.str_val = yytext; printf( "STRING(%s)", yylval.str_val); return CTE_S;}
{COMENTARIO}	/* IGNORAR TOKEN */
[\t\n]+			/* IGNORAR TOKEN */

"\n"      		
"\t"		



