%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"

int yylval;
int yystopparser=0;
FILE *yyin;
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

start				:		archivo 
archivo				:		{ printf("\t\t---INICIO PRINCIPAL DEL PROGRAMA---\n\n"); } VAR { printf("INICIO DECLARACIONES\n"); } bloqdeclaracion ENDVAR { printf("FIN DECLARACIONES\n"); };

bloqdeclaracion		:		bloqdeclaracion declaracion ;
bloqdeclaracion		:		declaracion ;

declaracion			:		{ printf("\tINICIO DECLARACION\n"); } { printf("\t\tINICIO TIPOS VARIABLES\n\t\t\t"); } CORCHETE_A listatipos CORCHETE_C { printf("\n\t\tFIN TIPOS VARIABLES\n"); } DOSPUNTOS { printf("\t\tINICIO LISTA VARIABLES\n\t\t\t"); } CORCHETE_A listavariables CORCHETE_C { printf("\n\t\tFIN LISTA VARIABLES\n"); } PYC { printf("\tFIN DECLARACION\n\n"); };

listatipos			:		listatipos COMA INTEGER { printf("INTEGER "); } |
							listatipos COMA FLOAT { printf("FLOAT "); };
listatipos			:		INTEGER { printf("INTEGER "); } |
							FLOAT { printf("FLOAT "); };
							
listavariables		:		listavariables COMA ID { printf("ID "); };
listavariables		:		ID { printf("ID "); };


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