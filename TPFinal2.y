%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"


int yystopparser=0;
FILE *yyin;
%}

%union {
int intval;
double val;
char *str_val;
}

%token <str_val>ID <int>CTE_E <double>CTE_R <str_val>CTE_S
%token C_REPEAT_A C_REPEAT_C C_IF_A C_IF_E C_IF_C
%token C_FILTER_A C_FILTER_C
%token PRINT READ
%token VAR ENDVAR CONST INTEGER FLOAT STRING
%token OP_ASIG OP_SUMARESTA OP_MULDIV
%token PARENTESIS_A PARENTESIS_C LLAVE_A LLAVE_C CORCHETE_A CORCHETE_C COMA PYC DOSPUNTOS GUIONBAJO
%token OP_IGUAL OP_DISTINTO OP_COMPARACION OP_LOGICO OP_NEGACION


%%

start				:		archivo ; /* SIMBOLO INICIAL */

/* DECLARACION GENERAL DE PROGRAMA
	- DECLARACIONES Y CUERPO DE PROGRAMA
	- CUERPO DE PROGRAMA
*/
archivo				:		{ printf("\t\t---INICIO PRINCIPAL DEL PROGRAMA---\n\n"); } VAR { printf("INICIO DECLARACIONES\n"); } bloqdeclaracion ENDVAR { printf("FIN DECLARACIONES\n\n"); } { printf("INICIO PROGRAMA\n"); } bloqprograma { printf("\n\n\t\t---FIN PRINCIPAL DEL PROGRAMA---\n\n"); };

/* REGLAS BLOQUE DE DECLARACIONES */
bloqdeclaracion		:		bloqdeclaracion declaracion ;
bloqdeclaracion		:		declaracion ;

declaracion			:		{ printf("\tINICIO DECLARACION\n\t\t"); } CORCHETE_A listatipos CORCHETE_C DOSPUNTOS CORCHETE_A listavariables CORCHETE_C PYC { printf("\tFIN DECLARACION\n\n"); };

listatipos			:		listatipos COMA INTEGER |
							listatipos COMA FLOAT 	;
listatipos			:		INTEGER |
							FLOAT	;
							
listavariables		:		listavariables COMA ID ;
listavariables		:		ID;
/* FIN REGLAS BLOQUE DE DECLARACIONES */

/* REGLAS BLOQUE DE CUERPO DE PROGRAMA */
bloqprograma		:		bloqprograma sentencia ;
bloqprograma		:		sentencia ;

sentencia			:		constante 	| /* DEFINICION DE CONSTANTE */
							asignacion	| 
							decision	| /* IF */
							bucle		; /* REPEAT */
							/*	FALTA filtro  */
							
constante			:		CONST ID OP_ASIG varconstante PYC ;
varconstante		:		CTE_E	|
							CTE_R	|
							CTE_S	;

asignacion			:		ID OP_ASIG varconstante PYC |
							ID OP_ASIG ID PYC			;
							
decision			:		C_IF_A PARENTESIS_A condicion PARENTESIS_C LLAVE_A {printf("\t");} bloqprograma LLAVE_C


condicion			:		comparacion											|
							OP_NEGACION PARENTESIS_A comparacion PARENTESIS_C	|
							comparacion OP_LOGICO comparacion					;


comparacion			:		expresion OP_COMPARACION expresion	;
							
expresion			:		termino							|
							expresion OP_SUMARESTA termino	;
							
termino				:		factor						|
							termino OP_MULDIV factor	;
							
factor				:		ID				|
							varconstante	;
							
bucle				:		C_REPEAT_A bloqprograma C_REPEAT_C PARENTESIS_A condicion PARENTESIS_C PYC ;						


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
	printf("\n\n\n----- Syntax Error -----\n");
	system ("Pause");
	exit (1);
}