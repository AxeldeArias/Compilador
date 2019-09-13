%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yylval;
int yystopparser=0;
FILE  *yyin;
char *yyltext;
char *yytext;

%}

%token C_REPEAT_A C_REPEAT_C C_IF_A C_IF_E C_IF_C
%token C_FILTER_A C_FILTER_C
%token PRINT READ
%token VAR ENDVAR CONST INTEGER FLOAT STRING
%token OP_ASIG OP_SUMARESTA OP_MULDIV
%token PARENTESIS_A PARENTESIS_C LLAVE_A LLAVE_C CORCHETE_A CORCHETE_C COMA PYC DOSPUNTOS GUIONBAJO
%token OP_IGUAL OP_DISTINTO OP_COMPARACION OP_LOGICO OP_NEGACION
%token ID CTE_E CTE_R CTE_S

%%
s : d p | p { printf("INICIO PRIMERO \n"); };
d : VAR dec ENDVAR { printf("DECLARACION DE VARIABLES  \n\n"); };
dec : ll dec | ll	{ printf("REGLA 3\n"); };
ll : CORCHETE_A ldt CORCHETE_C DOSPUNTOS CORCHETE_A ldv CORCHETE_C { printf("REGLA 4\n"); };
ldt : tipo COMA ldt | tipo { printf("DECLARACION: LISTA DE TIPOS \n"); };
tipo : INTEGER | FLOAT | STRING { printf("REGLA 5\n"); };
ldv : ID COMA ldv | ID | filtro COMA ldv | filtro { printf("DECLARACION: LISTA DE VARIABLES  \n"); };
p : cons | deci | asig | bucle { printf("\nINICIO DE PROGRAMA \n"); };
cons : CONST ID OP_ASIG cte { printf("PROGRAMA: DEFINICION DE CONSTANTE: "); };
cte : CTE_E | CTE_R | CTE_S {$1 = yylval ;printf("CTE es: %s\n", yylval);};
deci : C_IF_A PARENTESIS_A cond PARENTESIS_C LLAVE_A p LLAVE_C { printf("PROGRAMA: DECISION TIPO IF  \n"); };
cond : cmp | cmp OP_LOGICO cmp | OP_NEGACION cmp { printf("REGLA 6\n"); };
cmp : exp OP_COMPARACION exp { printf("REGLA 7\n"); };
asig : ID OP_ASIG exp | filtro OP_ASIG exp { printf("PROGRAMA: ASIGNACION  \n"); };
exp : t OP_SUMARESTA exp | t { printf("REGLA 8\n"); };
t : f OP_MULDIV t | f { printf("REGLA 9\n"); };
f : ID | cte | PARENTESIS_A exp PARENTESIS_C | filtro { printf("REGLA 10\n"); };
filtro : C_FILTER_A PARENTESIS_A cf COMA CORCHETE_A ldv CORCHETE_C PARENTESIS_C { printf("PROGRAMA: FILTRO \n"); };
cf : csf | csf OP_LOGICO csf | OP_NEGACION csf { printf("REGLA 11\n"); };
csf : GUIONBAJO OP_COMPARACION exp { printf("REGLA 12\n"); };
bucle : C_REPEAT_A p C_REPEAT_C cond PYC { printf("PROGRAMA: REPEAT  \n"); };


%%
int main(int argc,char *argv[]){
	if ((yyin = fopen(argv[1], "rt")) == NULL){
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
	}
	else{
		yyparse();
	}
	
	fclose(yyin);
	return 0;
}

int yyerror(void){
	printf("Syntax Error\n");
	system ("Pause");
	exit (1);
}




