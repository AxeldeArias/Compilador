%{
/******** INCLUDES **********/
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "inc\primitivas_pila_dinamica.c"
#include "y.tab.h"
/****************************/

<<<<<<< Updated upstream

/****** Estructuras pila  *********/
t_pila pilaPos;
t_pila pilaRepeat;
t_pila pilaFiltro;
/************************/

/****** DEFINES *********/
#define MAX_IDS 20
/************************/

/****** FUNCIONES *********/
int crearTerceto(char *operador, char *operando1, char *operando2);
void mostrarTerceto();
void modificarTerceto(int posicion, int inc);
char* negarSalto(char* operadorSalto);
/************************/

/****** VARIABLES GLOBALES *********/
int yystopparser=0;
FILE *yyin;
/***********************************/

/********* VARIABLES TERCETO ********/
=======
/********* DEFINES Y VARS GLOBALES ************/
int yystopparser=0;
FILE *yyin;
void exportarTablas();
/**********************************************/

/****** ELEMENTOS DE LAS PILAS  *********/
t_pila pilaPos;
t_pila pilaRepeat;
t_pila pilaFiltro;
/**********************************/


/************* ELEMENTOS NECESARIOS PARA TERCERTOS ********/
>>>>>>> Stashed changes
typedef struct
{
   int indice;      //INDICE DE TERCETO
   char dato1[40];  //OPERACION
   char dato2[40];  //OPERADOR1
   char dato3[40];  //OPERADOR2
} regTerceto;

regTerceto terceto;
regTerceto tablaTerceto[2048];

int numeroTerceto = 0;
char valorConstante[50];
char aux1[31], aux2[31], opSalto[6];

int indice_constante;
int indice_termino;
int indice_factor;
int indice_expresion;

int indice_condicion;
int indice_condicionI;
int indice_condicionD;

int indice_comparacion;
int indice_comparacionD;
int indice_comparacionI;
<<<<<<< Updated upstream

int indice_repeat;
int indice_filtro;

int indice_out;
int indice_in;

int indice_if;
/***********************************/

/********* VARIABLES IDS ********/
typedef struct
{
   char nombre[31];
   int tipo;
   char valor[31];  
   char longitud[5];
} regId;

regId tablaId[2048];
int numeroId = 0;

=======

int indice_repeat;
int indice_filtro;

int indice_out;
int indice_in;

int indice_if;

int crearTerceto(char *operador, char *operando1, char *operando2);
void mostrarTerceto();
void modificarTerceto(int posicion, int inc);
char* negarSalto(char* operadorSalto);
/**********************************************************************/

/****************** ELEMENTOS NECESARIOS PARA IDS *********************/
#define MAX_IDS 20
typedef struct
{
   char nombre[31];
   char tipo[31];
   char valor[31];  
   char longitud[5];
} regId;

regId tablaId[2048];
int numeroId = 0;

>>>>>>> Stashed changes
char cadAux[50];
char ids[MAX_IDS][32];
char tipoid[MAX_IDS][32];
int cantIds = 0;
int canttipos = 0;

<<<<<<< Updated upstream
void insertarIDs();
void mostrarID();
int existeID(char* id);
void insertarConstante(char* nombre, int tipo, char* valor);
void exportarTablas();

/***********************************/


=======
int idAsig1;
int idAsig2;

void insertarIDs();
void mostrarID();
int existeID(char* id);
void insertarConstante(char* nombre, char* tipo, char* valor);
/***********************************************************************/
>>>>>>> Stashed changes
%}


%union {
	int intval;
	double val;
	char *str_val;
}
%start start
%token <str_val>ID <int>CTE_E <double>CTE_R <str_val>CTE_S
%token C_REPEAT_A C_REPEAT_C C_IF_A C_IF_E
%token C_FILTER C_FILTER_REFENTEROS
%token PRINT READ
%token VAR ENDVAR CONST INTEGER FLOAT STRING
%token OP_ASIG OP_SUMA OP_RESTA OP_MUL OP_DIV
%token PARENTESIS_A PARENTESIS_C LLAVE_A LLAVE_C CORCHETE_A CORCHETE_C COMA PYC DOSPUNTOS
%token OP_IGUAL OP_DISTINTO OP_MENOR OP_MENORIGUAL OP_MAYOR OP_MAYORIGUAL OP_LOGICO_AND OP_LOGICO_OR OP_NEGACION


%%

start				:		archivo ; /* SIMBOLO INICIAL */

/* DECLARACION GENERAL DE PROGRAMA
	- DECLARACIONES Y CUERPO DE PROGRAMA
	- CUERPO DE PROGRAMA
*/
archivo				:		VAR bloqdeclaracion ENDVAR bloqprograma {exportarTablas();} ;

/* REGLAS BLOQUE DE DECLARACIONES */
bloqdeclaracion		:		bloqdeclaracion declaracion ;
bloqdeclaracion		:		declaracion ;

declaracion			:		CORCHETE_A listatipos CORCHETE_C DOSPUNTOS CORCHETE_A listavariables CORCHETE_C PYC {insertarIDs();};

listatipos			:		listatipos COMA listadato	|
							listadato					;

<<<<<<< Updated upstream
listadato			:		INTEGER {tipoid[canttipos++] = INTEGER; }	|
							FLOAT	{tipoid[canttipos++] = FLOAT; }	;

listavariables		:		listavariables COMA ID {strcpy(cadAux,yylval.str_val); strcpy(ids[cantIds], strtok(cadAux," ,:"));cantIds++;}|
							ID{strcpy(cadAux,yylval.str_val); strcpy(ids[cantIds], strtok(cadAux," ,:"));cantIds++;};
=======
listadato			:		INTEGER {sprintf(tipoid[canttipos++], "%s", "INTEGER"); }	|
							FLOAT	{sprintf(tipoid[canttipos++], "%s", "FLOAT"); }		;

listavariables		:		listavariables COMA ID {strcpy(cadAux,yylval.str_val); strcpy(ids[cantIds], strtok(cadAux," ,:"));cantIds++;}	|
							ID{strcpy(cadAux,yylval.str_val); strcpy(ids[cantIds], strtok(cadAux," ,:"));cantIds++;}						;
>>>>>>> Stashed changes
/* FIN REGLAS BLOQUE DE DECLARACIONES */

/* REGLAS BLOQUE DE CUERPO DE PROGRAMA */

<<<<<<< Updated upstream

start				:		bloqprograma ; /* SIMBOLO INICIAL */

bloqprograma		:		bloqprograma sentencia ;
bloqprograma		:		sentencia ;

sentencia			:		constante	|
							asignacion 	|
							decision	|
							bucle		|
							leer		|
							imprimir	|
							filtro		; /*SACAR*/
							
tiposoloid			: 		ID {strcpy(aux1, yylval.str_val);};

constante			:		CONST tiposoloid OP_ASIG CTE_E 
							{	itoa(yylval.intval, valorConstante, 10);} PYC 
							{	indice_constante = crearTerceto("=", aux1, valorConstante);
								insertarConstante(aux1, CTE_E, valorConstante);
							}		|
							CONST tiposoloid OP_ASIG CTE_R 
							{	gcvt(yylval.val, 10, valorConstante);} PYC 
							{	indice_constante = crearTerceto("=", aux1, valorConstante);
								insertarConstante(aux1, CTE_R, valorConstante);
							}		|
							CONST tiposoloid OP_ASIG CTE_S 
							{	strcpy(valorConstante, yylval.str_val);} PYC 
							{	indice_constante = crearTerceto("=", aux1, valorConstante);
								insertarConstante(aux1, CTE_S, valorConstante);
							}		;

asignacion			:		ID	
							{	//if(existeID(yylval.str_val))
									strcpy(aux1, yylval.str_val);}	OP_ASIG tipoasig PYC {crearTerceto("=", aux1, valorConstante);
								/*SINO ERROR PORQUE NO EXISTE*/
							}	;
tipoasig			:		varconstante 										|
							ID	
							{	//if(existeID(yylval.str_val))
									strcpy(valorConstante, yylval.str_val);
								/*SINO ERROR PORQUE NO EXISTE*/
							}		;
							
varconstante		:		CTE_E	{itoa(yylval.intval, valorConstante, 10);}	|
							CTE_R	{gcvt(yylval.val, 10, valorConstante);} 	;
							
decision			:		C_IF_A PARENTESIS_A condicion PARENTESIS_C LLAVE_A bloqprograma LLAVE_C 
							{	modificarTerceto(desapilar(&pilaPos), 0);
							}	|
							C_IF_A PARENTESIS_A condicion PARENTESIS_C LLAVE_A bloqprograma LLAVE_C 
							{	modificarTerceto(desapilar(&pilaPos), 1);
								indice_if = crearTerceto("JMP", "", "");
								apilar(&pilaPos, indice_if);
							} 
							C_IF_E LLAVE_A bloqprograma LLAVE_C	{modificarTerceto(desapilar(&pilaPos), 0);}	;
							
bucle				:		C_REPEAT_A
							{	indice_repeat = crearTerceto("ETQ_REPEAT", "", "");
								apilar(&pilaRepeat, indice_repeat);
							
							}
							bloqprograma C_REPEAT_C PARENTESIS_A condicion PARENTESIS_C PYC 
							{	
								modificarTerceto(numeroTerceto-1, (-1)*(numeroTerceto - desapilar(&pilaRepeat) ));
								
							};							

condicion			:		comparacion
							{	sprintf(aux1, "[ %d ]", indice_comparacion);
								//itoa(indice_comparacion, aux1, 10);
								indice_condicion = crearTerceto(opSalto, aux1, "");
								apilar(&pilaPos, indice_condicion);
								//mostrarPila(pilaPos);
							}	|
							OP_NEGACION PARENTESIS_A comparacion PARENTESIS_C
							{	sprintf(aux1, "[ %d ]", indice_comparacion);
								//itoa(indice_comparacion, aux1, 10);
								indice_condicion = crearTerceto(negarSalto(opSalto), aux1, "");
								apilar(&pilaPos, indice_condicion);
								//mostrarPila(pilaPos);
							}	|
							comparacion_i OP_LOGICO_AND comparacion_d
							{	sprintf(aux1, "[ %d ]", indice_comparacionI);
								sprintf(aux2, "[ %d ]", indice_comparacionD);
								
								//itoa(indice_comparacionI, aux1, 10);
								//itoa(indice_comparacionD, aux2, 10);
								
								indice_condicion = crearTerceto("AND", aux1, aux2);
								
								sprintf(aux1, "[ %d ]", numeroTerceto);
								//itoa(numeroTerceto, aux1, 10);
								
								indice_condicion = crearTerceto("JZ", aux1, "");
								apilar(&pilaPos, indice_condicion);
								//mostrarPila(pilaPos);
							}	|
							comparacion_i OP_LOGICO_OR comparacion_d 
							{	sprintf(aux1, "[ %d ]", indice_comparacionI);
								sprintf(aux2, "[ %d ]", indice_comparacionD);
								
								//itoa(indice_comparacionI, aux1, 10);
								//itoa(indice_comparacionD, aux2, 10);
								
								indice_condicion = crearTerceto("AND", aux1, aux2);
								
								sprintf(aux1, "[ %d ]", numeroTerceto);
								//itoa(numeroTerceto, aux1, 10);
								
								indice_condicion = crearTerceto("JZ", aux1, "");
								apilar(&pilaPos, indice_condicion);
								//mostrarPila(pilaPos);
							}	;

comparacion_i		:		comparacion { indice_comparacionI = indice_comparacion; } ;
comparacion_d		:		comparacion { indice_comparacionD = indice_comparacion; } ;


comparacion			:		expresion_i op_comparacion expresion_d	
							{	sprintf(aux1, "[ %d ]", indice_condicionI);
								sprintf(aux2, "[ %d ]", indice_condicionD);
								
								//itoa(indice_condicionI, aux1, 10);
								//itoa(indice_condicionD, aux2, 10);
								
								indice_comparacion = crearTerceto("CMP", aux1, aux2);
							}	|
							filtro op_comparacion expresion_d
							{	sprintf(aux2, "[ %d ]", indice_condicionD);
							
								//itoa(indice_condicionD, aux2, 10);
								
								indice_comparacion = crearTerceto("CMP", "_auxFiltro", aux2);
							}	;
							
							
expresion_i			: 		expresion { indice_condicionI = indice_expresion; };
expresion_d			:		expresion { indice_condicionD = indice_expresion; };

op_comparacion      :       OP_MENOR {strcpy(opSalto, "JB");} 		| 
							OP_MENORIGUAL {strcpy(opSalto, "JBE");}	| 
							OP_MAYOR {strcpy(opSalto, "JA");}		| 
							OP_MAYORIGUAL {strcpy(opSalto, "JAE");}	| 
							OP_IGUAL {strcpy(opSalto, "JE");}		| 
							OP_DISTINTO	{strcpy(opSalto, "JNE");}	;



expresion			:		termino	{ indice_expresion = indice_termino; }		|
							expresion OP_SUMA termino 
							{	sprintf(aux1, "[ %d ]", indice_expresion);
								sprintf(aux2, "[ %d ]", indice_termino);
							
								//itoa(indice_expresion, aux1, 10);
								//itoa(indice_termino, aux2, 10);
							
								indice_expresion = crearTerceto("ADD", aux1, aux2); 
							}		|
							expresion OP_RESTA termino 
							{	sprintf(aux1, "[ %d ]", indice_expresion);
								sprintf(aux2, "[ %d ]", indice_termino);
								
								//itoa(indice_expresion, aux1, 10);
								//itoa(indice_termino, aux2, 10);
							
								indice_expresion = crearTerceto("SUB", aux1, aux2); 
							}		;

termino				:		factor { indice_termino = indice_factor; }				|
							termino OP_MUL factor 
							{
								sprintf(aux1, "[ %d ]", indice_termino);
								sprintf(aux2, "[ %d ]", indice_factor);
								
								//itoa(indice_termino, aux1, 10);
								//itoa(indice_factor, aux2, 10);
								
								indice_termino = crearTerceto("MUL", aux1, aux2);
							}	|
							termino OP_DIV factor
							{	sprintf(aux1, "[ %d ]", indice_termino);
								sprintf(aux2, "[ %d ]", indice_factor);
							
								//itoa(indice_termino, aux1, 10);
								//itoa(indice_factor, aux2, 10);
								
								indice_termino = crearTerceto("DIV", aux1, aux2);
							}	;

factor				:		ID 
							{	//if(existeID(yylval.str_val))
									indice_factor = crearTerceto(yylval.str_val,"","");
								/*SINO ERROR PORQUE NO EXISTE*/
							}				|
							varconstante {indice_factor = crearTerceto(valorConstante, "", "");}	|
							PARENTESIS_A expresion PARENTESIS_C {indice_factor = indice_expresion;}	;



imprimir			:		PRINT CTE_S {
								strcpy(aux1, yylval.str_val);
								indice_out = crearTerceto("output", aux1, "");
							}	PYC	|
							PRINT ID { 
								//if(existeID(yylval.str_val))
									strcpy(aux1, yylval.str_val);
									indice_out = crearTerceto("output", aux1, "");
								/*SINO ERROR PORQUE NO EXISTE*/
							}	PYC	;
leer				:		READ ID	{
								//if(existeID(yylval.str_val))
									strcpy(aux1, yylval.str_val);
									indice_in = crearTerceto("input", aux1, "");
								/*SINO ERROR PORQUE NO EXISTE*/
							}	PYC	;

filtro				:		C_FILTER PARENTESIS_A condfiltro COMA CORCHETE_A listvarfiltro CORCHETE_C PARENTESIS_C
							{	while(!pila_vacia(&pilaFiltro))
								{
									modificarTerceto(desapilar(&pilaFiltro), 0);
								}
							
							}	;

condfiltro			:		C_FILTER_REFENTEROS op_comparacion expresion ;
/*							C_FILTER_REFENTEROS op_comparacion expresion_i OP_LOGICO_AND C_FILTER_REFENTEROS op_comparacion expresion_d |
							C_FILTER_REFENTEROS op_comparacion expresion_i OP_LOGICO_OR C_FILTER_REFENTEROS op_comparacion expresion_d ;
*/
listvarfiltro		:		listvarfiltro COMA ID 
							{	//if(existeID(yylval.str_val))
									strcpy(aux1, yylval.str_val);
									indice_filtro = crearTerceto(aux1, "", "");
								
									sprintf(aux1, "[ %d ]", indice_expresion);
									sprintf(aux2, "[ %d ]", numeroTerceto-1);
									
									//itoa(indice_expresion, aux1, 10);
									//itoa((numeroTerceto-1), aux2, 10);
									crearTerceto("CMP", aux1, aux2);
								
									sprintf(aux1, "[ %d ]", numeroTerceto+3);
									
									//itoa((numeroTerceto+3), aux1, 10);
									crearTerceto(negarSalto(opSalto), aux1, "");
								
									sprintf(aux1, "[ %d ]", numeroTerceto-3);
									
									//itoa((numeroTerceto-3), aux1, 10);
									crearTerceto("=", "_auxFiltro", aux1);
									crearTerceto("JMP", "", "");
									apilar(&pilaFiltro, numeroTerceto-1);							
								/*SINO ERROR PORQUE NO EXISTE*/
							}	|
							ID	
							{	//if(existeID(yylval.str_val))
									strcpy(aux1, yylval.str_val);
									indice_filtro = crearTerceto(aux1, "", "");
								
									sprintf(aux1, "[ %d ]", indice_expresion);
									sprintf(aux2, "[ %d ]", numeroTerceto-1);
									
									//itoa(indice_expresion, aux1, 10);
									//itoa((numeroTerceto-1), aux2, 10);
									crearTerceto("CMP", aux1, aux2);
								
									sprintf(aux1, "[ %d ]", numeroTerceto+3);

									//itoa((numeroTerceto+3), aux1, 10);
									crearTerceto(negarSalto(opSalto), aux1, "");
								
									sprintf(aux1, "[ %d ]", numeroTerceto-3);
									
									//itoa((numeroTerceto-3), aux1, 10);
									crearTerceto("=", "_auxFiltro", aux1);
									crearTerceto("JMP", "", "");
									apilar(&pilaFiltro, numeroTerceto-1);
								/*SINO ERROR PORQUE NO EXISTE*/
							}	;

%%
=======
bloqprograma		:		bloqprograma sentencia ;
bloqprograma		:		sentencia ;

sentencia			:		constante	|
							asignacion 	|
							decision	|
							bucle		|
							leer		|
							imprimir	|
							filtro		; /*SACAR*/
							
tiposoloid			: 		ID {strcpy(aux1, yylval.str_val);};

constante			:		CONST tiposoloid OP_ASIG CTE_E 
							{	itoa(yylval.intval, valorConstante, 10);} PYC 
							{	indice_constante = crearTerceto("=", aux1, valorConstante);
								insertarConstante(aux1, "CONST_INTEGER", valorConstante);
							}		|
							CONST tiposoloid OP_ASIG CTE_R 
							{	gcvt(yylval.val, 10, valorConstante);} PYC 
							{	indice_constante = crearTerceto("=", aux1, valorConstante);
								insertarConstante(aux1, "CONST_FLOAT", valorConstante);
							}		|
							CONST tiposoloid OP_ASIG CTE_S 
							{	strcpy(valorConstante, yylval.str_val);} PYC 
							{	indice_constante = crearTerceto("=", aux1, valorConstante);
								insertarConstante(aux1, "CONST_STRING", valorConstante);
							}		;

asignacion			:		ID	
							{	if((idAsig1 = existeID(yylval.str_val)) != -1) 
									strcpy(aux1, yylval.str_val);
								else
									yyerror("SINTAX ERROR: ID no declarado anteriormente");
							}	OP_ASIG tipoasig PYC {crearTerceto("=", aux1, valorConstante);}	;
tipoasig			:		varconstante
							{ 	if(strcmp(tablaId[idAsig1].tipo, aux2) != 0)
									yyerror("SINTAX ERROR: Asignacion de dos tipos disntitos");
							}
							|
							ID	
							{	if((idAsig2 = existeID(yylval.str_val)) != -1) {
									if(strcmp(tablaId[idAsig1].tipo, tablaId[idAsig2].tipo) != 0)
										yyerror("SINTAX ERROR: Asignacion de dos tipos disntitos");
									else
										strcpy(valorConstante, yylval.str_val);
								}
								else
									yyerror("SINTAX ERROR: ID no declarado anteriormente");
							}		;
							
varconstante		:		CTE_E	{itoa(yylval.intval, valorConstante, 10); strcpy(aux2, "INTEGER");}	|
							CTE_R	{gcvt(yylval.val, 10, valorConstante); strcpy(aux2, "FLOAT");} 	;
							
decision			:		C_IF_A PARENTESIS_A condicion PARENTESIS_C LLAVE_A bloqprograma LLAVE_C 
							{	modificarTerceto(desapilar(&pilaPos), 0);
							}	|
							C_IF_A PARENTESIS_A condicion PARENTESIS_C LLAVE_A bloqprograma LLAVE_C 
							{	modificarTerceto(desapilar(&pilaPos), 1);
								indice_if = crearTerceto("JMP", "", "");
								apilar(&pilaPos, indice_if);
							} 
							C_IF_E LLAVE_A bloqprograma LLAVE_C	{modificarTerceto(desapilar(&pilaPos), 0);}	;
							
bucle				:		C_REPEAT_A
							{	indice_repeat = crearTerceto("ETQ_REPEAT", "", "");
								apilar(&pilaRepeat, indice_repeat);
							
							}
							bloqprograma C_REPEAT_C PARENTESIS_A condicion PARENTESIS_C PYC 
							{	
								modificarTerceto(numeroTerceto-1, (-1)*(numeroTerceto - desapilar(&pilaRepeat) ));
								
							};							

condicion			:		comparacion
							{	sprintf(aux1, "[ %d ]", indice_comparacion);
								indice_condicion = crearTerceto(opSalto, aux1, "");
								apilar(&pilaPos, indice_condicion);
							}	|
							OP_NEGACION PARENTESIS_A comparacion PARENTESIS_C
							{	sprintf(aux1, "[ %d ]", indice_comparacion);
								indice_condicion = crearTerceto(negarSalto(opSalto), aux1, "");
								apilar(&pilaPos, indice_condicion);
							}	|
							comparacion_i OP_LOGICO_AND comparacion_d
							{	sprintf(aux1, "[ %d ]", indice_comparacionI);
								sprintf(aux2, "[ %d ]", indice_comparacionD);
								
								indice_condicion = crearTerceto("AND", aux1, aux2);
								
								sprintf(aux1, "[ %d ]", numeroTerceto);

								indice_condicion = crearTerceto("JZ", aux1, "");
								apilar(&pilaPos, indice_condicion);
							}	|
							comparacion_i OP_LOGICO_OR comparacion_d 
							{	sprintf(aux1, "[ %d ]", indice_comparacionI);
								sprintf(aux2, "[ %d ]", indice_comparacionD);
								
								indice_condicion = crearTerceto("OR", aux1, aux2);
								
								sprintf(aux1, "[ %d ]", numeroTerceto);
								
								indice_condicion = crearTerceto("JZ", aux1, "");
								apilar(&pilaPos, indice_condicion);
							}	;

comparacion_i		:		comparacion { indice_comparacionI = indice_comparacion; } ;
comparacion_d		:		comparacion { indice_comparacionD = indice_comparacion; } ;


comparacion			:		expresion_i op_comparacion expresion_d	
							{	sprintf(aux1, "[ %d ]", indice_condicionI);
								sprintf(aux2, "[ %d ]", indice_condicionD);
								
								indice_comparacion = crearTerceto("CMP", aux1, aux2);
							}	|
							filtro op_comparacion expresion_d
							{	sprintf(aux2, "[ %d ]", indice_condicionD);
								
								indice_comparacion = crearTerceto("CMP", "_auxFiltro", aux2);
							}	;
							
							
expresion_i			: 		expresion { indice_condicionI = indice_expresion; };
expresion_d			:		expresion { indice_condicionD = indice_expresion; };

op_comparacion      :       OP_MENOR {strcpy(opSalto, "JB");} 		| 
							OP_MENORIGUAL {strcpy(opSalto, "JBE");}	| 
							OP_MAYOR {strcpy(opSalto, "JA");}		| 
							OP_MAYORIGUAL {strcpy(opSalto, "JAE");}	| 
							OP_IGUAL {strcpy(opSalto, "JE");}		| 
							OP_DISTINTO	{strcpy(opSalto, "JNE");}	;



expresion			:		termino	{ indice_expresion = indice_termino; }		|
							expresion OP_SUMA termino 
							{	sprintf(aux1, "[ %d ]", indice_expresion);
								sprintf(aux2, "[ %d ]", indice_termino);

								indice_expresion = crearTerceto("ADD", aux1, aux2); 
							}		|
							expresion OP_RESTA termino 
							{	sprintf(aux1, "[ %d ]", indice_expresion);
								sprintf(aux2, "[ %d ]", indice_termino);
							
								indice_expresion = crearTerceto("SUB", aux1, aux2); 
							}		;

termino				:		factor { indice_termino = indice_factor; }				|
							termino OP_MUL factor 
							{
								sprintf(aux1, "[ %d ]", indice_termino);
								sprintf(aux2, "[ %d ]", indice_factor);
								
								indice_termino = crearTerceto("MUL", aux1, aux2);
							}	|
							termino OP_DIV factor
							{	sprintf(aux1, "[ %d ]", indice_termino);
								sprintf(aux2, "[ %d ]", indice_factor);
								
								indice_termino = crearTerceto("DIV", aux1, aux2);
							}	;

factor				:		ID 
							{	//if(existeID(yylval.str_val))
									indice_factor = crearTerceto(yylval.str_val,"","");
								/*SINO ERROR PORQUE NO EXISTE*/
							}				|
							varconstante {indice_factor = crearTerceto(valorConstante, "", "");}	|
							PARENTESIS_A expresion PARENTESIS_C {indice_factor = indice_expresion;}	;



imprimir			:		PRINT CTE_S {
								strcpy(aux1, yylval.str_val);
								indice_out = crearTerceto("output", aux1, "");
							}	PYC	|
							PRINT ID { 
								//if(existeID(yylval.str_val))
									strcpy(aux1, yylval.str_val);
									indice_out = crearTerceto("output", aux1, "");
								/*SINO ERROR PORQUE NO EXISTE*/
							}	PYC	;
leer				:		READ ID	{
								//if(existeID(yylval.str_val))
									strcpy(aux1, yylval.str_val);
									indice_in = crearTerceto("input", aux1, "");
								/*SINO ERROR PORQUE NO EXISTE*/
							}	PYC	;

filtro				:		C_FILTER PARENTESIS_A condfiltro COMA CORCHETE_A listvarfiltro CORCHETE_C PARENTESIS_C
							{	while(!pila_vacia(&pilaFiltro))
								{
									modificarTerceto(desapilar(&pilaFiltro), 0);
								}
							
							}	;

condfiltro			:		C_FILTER_REFENTEROS op_comparacion expresion ;
/*							C_FILTER_REFENTEROS op_comparacion expresion_i OP_LOGICO_AND C_FILTER_REFENTEROS op_comparacion expresion_d |
							C_FILTER_REFENTEROS op_comparacion expresion_i OP_LOGICO_OR C_FILTER_REFENTEROS op_comparacion expresion_d ;
*/
listvarfiltro		:		listvarfiltro COMA ID 
							{	//if(existeID(yylval.str_val))
									strcpy(aux1, yylval.str_val);
									indice_filtro = crearTerceto(aux1, "", "");
								
									sprintf(aux1, "[ %d ]", indice_expresion);
									sprintf(aux2, "[ %d ]", numeroTerceto-1);
									crearTerceto("CMP", aux1, aux2);
								
									sprintf(aux1, "[ %d ]", numeroTerceto+3);
									crearTerceto(negarSalto(opSalto), aux1, "");
								
									sprintf(aux1, "[ %d ]", numeroTerceto-3);
									
									crearTerceto("=", "_auxFiltro", aux1);
									crearTerceto("JMP", "", "");
									apilar(&pilaFiltro, numeroTerceto-1);							
								/*SINO ERROR PORQUE NO EXISTE*/
							}	|
							ID	
							{	//if(existeID(yylval.str_val))
									strcpy(aux1, yylval.str_val);
									indice_filtro = crearTerceto(aux1, "", "");
								
									sprintf(aux1, "[ %d ]", indice_expresion);
									sprintf(aux2, "[ %d ]", numeroTerceto-1);
									crearTerceto("CMP", aux1, aux2);
								
									sprintf(aux1, "[ %d ]", numeroTerceto+3);
									crearTerceto(negarSalto(opSalto), aux1, "");
								
									sprintf(aux1, "[ %d ]", numeroTerceto-3);
									
									crearTerceto("=", "_auxFiltro", aux1);
									crearTerceto("JMP", "", "");
									apilar(&pilaFiltro, numeroTerceto-1);
								/*SINO ERROR PORQUE NO EXISTE*/
							}	;





%%
/* *******************************************************************************
								DESARROLLO DE FUNCIONES
	****************************************************************************** */

>>>>>>> Stashed changes
int main(int argc,char *argv[]){
	
	if ((yyin = fopen(argv[1], "rt")) == NULL){
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
		return 0;
	}
	
<<<<<<< Updated upstream
	/* CREAR PILAS */
	crearPila(&pilaPos);
	crearPila(&pilaRepeat);
	crearPila(&pilaFiltro);
	/* *********** */
=======
	/* ************ CREACION DE PILAS *********** */
	crearPila(&pilaPos);
	crearPila(&pilaRepeat);
	crearPila(&pilaFiltro);
	/* ****************************************** */
>>>>>>> Stashed changes
	
	
	
	yyparse();

	fclose(yyin);
	return 0;
}

int yyerror(char * mensaje){
	printf("\n\n\n----- %s -----\n", mensaje);
	system ("Pause");
	exit (1);
}


int crearTerceto(char *operador, char *operando1, char *operando2)
{
	tablaTerceto[numeroTerceto].indice = numeroTerceto;
	
	strcpy(tablaTerceto[numeroTerceto].dato1, operador);
	strcpy(tablaTerceto[numeroTerceto].dato2, operando1);
	strcpy(tablaTerceto[numeroTerceto].dato3, operando2);
	//printf("TERCERTO: %d - OPERADOR: %s - OPERANDO1: %s - OPERANDO2: %s\n", tablaTerceto[numeroTerceto].indice, tablaTerceto[numeroTerceto].dato1, tablaTerceto[numeroTerceto].dato2, tablaTerceto[numeroTerceto].dato3);
	return numeroTerceto++;
}

void modificarTerceto(int posicion, int inc)
{
	//printf("REEMPLAZANDO: POS %d - INC %d - NUMTERCERO %d\n", posicion, inc, numeroTerceto);
	//printf("EN POS: %s - %s - %s\n", tablaTerceto[posicion].dato1, tablaTerceto[posicion].dato2, tablaTerceto[posicion].dato3);
	
	sprintf(tablaTerceto[posicion].dato2, "[ %d ]", numeroTerceto + inc);
	//itoa((numeroTerceto + inc), tablaTerceto[posicion].dato2, 10);

}

void mostrarTerceto()
{
	for(int i = 0; i < numeroTerceto; i++)
		printf("TERCERTO: %d - OPERADOR: %s - OPERANDO1: %s - OPERANDO2: %s\n", tablaTerceto[i].indice, tablaTerceto[i].dato1, tablaTerceto[i].dato2, tablaTerceto[i].dato3);

}

char* negarSalto(char* operadorSalto)
{
	if (strcmp(operadorSalto, "JE") == 0) // IGUAL
	{
		return "JEN"; // DISTINTO
	}
	if (strcmp(operadorSalto, "JNE") == 0) // DISTINTO
	{
		return "JE"; //IGUAL
	}
	if (strcmp(operadorSalto, "JB") == 0) // MENOR
	{
		return "JAE"; // MAYOR O IGUAL
	}
	if (strcmp(operadorSalto, "JA") == 0) //MAYOR
	{
		return "JBE"; //MENOR O IGUAL
	}
	if (strcmp(operadorSalto, "JBE") == 0) //MENOR O IGUAL
	{
		return "JA";	//MAYOR
	}
	if (strcmp(operadorSalto, "JAE") == 0) //MAYOR O IGUAL
	{
		return "JB"; //MENOR
	}
	if (strcmp(operadorSalto, "JZ") == 0) //
	{
		return "JNZ";
	}
	if (strcmp(operadorSalto, "JNZ") == 0)
	{
		return "JZ";
	}
}

void insertarIDs(){
	if(cantIds > canttipos) {
		cantIds = canttipos;
	}
	for(int i = 0; i < cantIds ; i++) {
		/*SI NO EXISTE, INSERTO*/
<<<<<<< Updated upstream
		if(!existeID(ids[i])) 
		{
			strcpy(tablaId[numeroId].nombre, ids[i]);
			tablaId[numeroId].tipo = tipoid[i];
=======
		if(existeID(ids[i]) == -1) 
		{
			strcpy(tablaId[numeroId].nombre, ids[i]);
			strcpy(tablaId[numeroId].tipo, tipoid[i]);
>>>>>>> Stashed changes
			strcpy(tablaId[numeroId].valor, "--");
			strcpy(tablaId[numeroId].longitud, "");
			numeroId++;
		}
		/*SI EXISTE, ERROR*/
	}

	memset( ids, '\0', MAX_IDS );
	memset( tipoid, '\0', MAX_IDS );
	cantIds = 0;
	canttipos = 0;


}

<<<<<<< Updated upstream
void insertarConstante(char* nombre, int tipo, char* valor)
{
	char auxLongitud[31];
	
	if(!existeID(nombre)) {
		strcpy(tablaId[numeroId].nombre, nombre);
		tablaId[numeroId].tipo = tipo;
		strcpy(tablaId[numeroId].valor, valor);
		if(tipo == CTE_S){
=======
void insertarConstante(char* nombre, char* tipo, char* valor)
{
	char auxLongitud[31];
	
	if(existeID(nombre) == -1) {
		strcpy(tablaId[numeroId].nombre, nombre);
		strcpy(tablaId[numeroId].tipo, tipo);
		strcpy(tablaId[numeroId].valor, valor);
		if(strcmp(tipo, "STRING") == 0){
>>>>>>> Stashed changes
			sprintf(tablaId[numeroId].longitud, "%d", strlen(tablaId[numeroId].valor) - 2);
		}
		else
			strcpy(tablaId[numeroId].longitud, "");
			
		numeroId++;
	}
	/* SINO ERROR PORQUE YA EXISTE*/
		
	
}

void mostrarID()
{
	for(int i = 0; i < numeroId; i++)
<<<<<<< Updated upstream
		printf("ID: %d - NOMBRE: %s - TIPO: %d - VALOR: %s - LONGITUD: %s\n", i, tablaId[i].nombre, tablaId[i].tipo, tablaId[i].valor, tablaId[i].longitud);
=======
		printf("ID: %d - NOMBRE: %s - TIPO: %s - VALOR: %s - LONGITUD: %s\n", i, tablaId[i].nombre, tablaId[i].tipo, tablaId[i].valor, tablaId[i].longitud);
>>>>>>> Stashed changes

}

int existeID(char* id)
{
	for(int i = 0; i < numeroId; i++)
	{
		if(strcmp(tablaId[i].nombre, id) == 0)
<<<<<<< Updated upstream
			return 1;
	}
	return 0;
=======
			return i;
	}
	return -1;	
>>>>>>> Stashed changes
}



/* EXPORTACION DE TABLAS */
void exportarTablas()
{
	FILE *ts = fopen("ts.txt", "wt");
	FILE *intermedia = fopen("intermedia.txt", "wt");
	
	fprintf(ts, "NOMBRE\t\t\t\tTIPO\t\t\t\tVALOR\t\t\tLONGITUD\n");
	
<<<<<<< Updated upstream
	/* IDs */
	for(int i = 0; i < numeroId; i++) {
		fprintf(ts, "%-30s%-30s%-30s%s\n", tablaId[i].nombre, (tablaId[i].tipo == 273 ? "INTEGER" : "FLOAT"), tablaId[i].valor, tablaId[i].longitud);
=======
	for(int i = 0; i < numeroId; i++) {
		fprintf(ts, "%-30s%-30s%-30s%s\n", tablaId[i].nombre, tablaId[i].tipo, tablaId[i].valor, tablaId[i].longitud);
>>>>>>> Stashed changes
	}
	
	
	for(int i = 0; i < numeroTerceto; i++) {
		fprintf(intermedia, "|  %d  | ( %s, %s, %s )\n", tablaTerceto[i].indice, tablaTerceto[i].dato1, tablaTerceto[i].dato2, tablaTerceto[i].dato3);
	}
	
	fclose(ts);
	fclose(intermedia);
	
<<<<<<< Updated upstream
}
=======
}

/* GENERACION DE ASSEMBLER */
void generarAssembler(){
	FILE *codAssembler = fopen("Final.asm", "wt");
	
	fprintf(codAssembler, 	"include macros2.asm\n" +
							"include number.asm\n\n" +
							".MODEL LARGE\n" +
							".386\n" +
							".STACK 200h\n\n" +
							"MAXTEXTSIZE equ 50\n\n" +
							".DATA\n");
	
}
>>>>>>> Stashed changes
