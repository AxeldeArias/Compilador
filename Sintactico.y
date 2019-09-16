%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"

#define MAX_IDS 20


int yystopparser=0;

FILE *yyin;
char tituloTS[] = "NOMBRE\t\t\t\tTIPO\t\t\t\tVALOR\t\t\tLONGITUD\n";
void insertarEnTabla(char*,char*,char*,int,double);
char cadAux[50];
char* ptr;

int existeID(char *);
char ids[MAX_IDS][32];
int tipoid[MAX_IDS];
int cantIds = 0;
int canttipos = 0;
int existeCTE(char *);
void insertarIds();
%} 


%union {
int intval;
double val;
char *str_val;
}

%token <str_val>ID <int>CTE_E <double>CTE_R <str_val>CTE_S
%token C_REPEAT_A C_REPEAT_C C_IF_A C_IF_E C_IF_C
%token C_FILTER C_FILTER_REFENTEROS
%token PRINT READ
%token VAR ENDVAR CONST INTEGER FLOAT STRING
%token OP_ASIG OP_SUMARESTA OP_MULDIV
%token PARENTESIS_A PARENTESIS_C LLAVE_A LLAVE_C CORCHETE_A CORCHETE_C COMA PYC DOSPUNTOS
%token OP_COMPARACION OP_LOGICO OP_NEGACION


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

declaracion			:		CORCHETE_A listatipos CORCHETE_C DOSPUNTOS CORCHETE_A listavariables CORCHETE_C PYC {insertarIds();};

listatipos			:		listatipos COMA listadato|
							listadato;

listadato			:		INTEGER {tipoid[canttipos++] = 0; }	|
							FLOAT	{tipoid[canttipos++] = 1; }	;
							
listavariables		:		listavariables COMA ID {strcpy(cadAux,yylval.str_val);ptr = strtok(cadAux," ,:");strcpy(ids[cantIds],ptr);cantIds++;}|
							ID{strcpy(cadAux,yylval.str_val);ptr = strtok(cadAux," ,:");strcpy(ids[cantIds],ptr);cantIds++;};
/* FIN REGLAS BLOQUE DE DECLARACIONES */

/* REGLAS BLOQUE DE CUERPO DE PROGRAMA */
bloqprograma		:		bloqprograma sentencia ;
bloqprograma		:		sentencia ;

sentencia			:		constante 	| /* DEFINICION DE CONSTANTE */
							asignacion	| 
							decision	| /* IF */
							bucle		| /* REPEAT */
							imprimir	| /* PRINT */
							leer		; /* READ */
							
imprimir			:		PRINT CTE_S	PYC	|
							PRINT ID PYC	;
leer				:		READ ID	PYC		;
							
							
constante			:		CONST ID OP_ASIG varconstante PYC	|
							CONST ID OP_ASIG CTE_S PYC	{insertarEnTabla(cadAux,"CONST_STR",yylval.str_val,0,0);}		;
varconstante		:		CTE_E	|
							CTE_R	;

asignacion			:		ID OP_ASIG varconstante PYC |
							ID OP_ASIG ID PYC			;
							
decision			:		C_IF_A PARENTESIS_A condicion PARENTESIS_C LLAVE_A bloqprograma LLAVE_C ;
/* VA CON ELSE? */

condicion			:		comparacion											|
							OP_NEGACION PARENTESIS_A comparacion PARENTESIS_C	|
							comparacion OP_LOGICO comparacion					;


comparacion			:		expresion OP_COMPARACION expresion	|
							filtro OP_COMPARACION expresion		;
							
expresion			:		termino							|
							expresion OP_SUMARESTA termino	;
							
termino				:		factor						|
							termino OP_MULDIV factor	;
							
factor				:		ID				|
							varconstante	|
							PARENTESIS_A expresion PARENTESIS_C;
							
bucle				:		C_REPEAT_A bloqprograma C_REPEAT_C PARENTESIS_A condicion PARENTESIS_C PYC ;

filtro				:		C_FILTER PARENTESIS_A condfiltro COMA CORCHETE_A listavariables CORCHETE_C PARENTESIS_C	;

condfiltro			:		C_FILTER_REFENTEROS OP_COMPARACION expresion |
							C_FILTER_REFENTEROS OP_COMPARACION expresion OP_LOGICO C_FILTER_REFENTEROS OP_COMPARACION expresion ;

%%
int main(int argc,char *argv[]){
	
  FILE *archTS = fopen("ts.txt","wt");
	if ((yyin = fopen(argv[1], "rt")) == NULL){
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
	}
	else{
	fwrite(tituloTS,sizeof(char), sizeof(tituloTS)-1, archTS);
    fclose(archTS);
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

void insertarIds(){
	int i;
	if(cantIds > canttipos) {
		cantIds = canttipos;
	}
	for(i=0;i<cantIds;i++) {
		if(existeID(ids[i])) 
			insertarEnTabla(ids[i],(tipoid[i] == 1 ? "FLOAT" : "INTEGER"),"--",0,0);
		
	}
	
	memset( ids, '\0', MAX_IDS );
	memset( tipoid, '\0', MAX_IDS );
	cantIds = 0;
	canttipos = 0;
		
		
}

int existeID(char *id){
  FILE *archTS2 = fopen("ts.txt","rt");
  char linea[100];
  char *aux,*ptr;
  char nombre[30];
  
  fgets(linea,sizeof(linea),archTS2);
  while(fgets(linea,sizeof(linea),archTS2)!=NULL)
  {
	aux=strchr(linea,'\n');
	aux-=62;
        *aux='\0';
        aux-=30;
	strcpy(nombre,aux);
	strtok(nombre," ");
        	if(strcmp(nombre,id)==0){
			fclose(archTS2);
			return 0;
		}
  }

  fclose(archTS2);
  return 1;
}

int existeCTE(char *cte){
  FILE *archTS2 = fopen("ts.txt","rt");
  char linea[100];
  char *aux,*ptr;
  char nombre[30];

	fgets(linea,sizeof(linea),archTS2);
	while(fgets(linea,sizeof(linea),archTS2)!=NULL)
    	{
	aux=strchr(linea,'\n');
	aux-=62;
        *aux='\0';
        aux-=30;
	strcpy(nombre,aux);
	strtok(nombre," ");
        	if(strcmp(nombre,cte)==0){
			fclose(archTS2);
			return 0;
		}
    	}

   fclose(archTS2);
   return 1;
}

void insertarEnTabla(char* nombreSimbolo,char* tipoSimbolo,char* valorString,int valorInteger, double valorFloat){
  FILE *archTS2 = fopen("ts.txt","a");
  char valor[20];
  char guionBajo[30]="_";

	if(strcmp(tipoSimbolo,"FLOAT")==0 || strcmp(tipoSimbolo,"INTEGER")==0 || strcmp(tipoSimbolo,"STRING")==0)
		fprintf(archTS2,"%-30s%-30s%-30s%02d\n",nombreSimbolo,tipoSimbolo,"--",strlen(nombreSimbolo));
	else{
	
	if(strcmp(tipoSimbolo,"CONST_INT") == 0){
		sprintf(valor,"%d",valorInteger);
		if(existeCTE((strcmp(nombreSimbolo, "") == 0 ? strcat(guionBajo,valor) : nombreSimbolo)) !=0 )
			fprintf(archTS2,"%-30s%-30s%-30s%02d\n",guionBajo,tipoSimbolo,valor,strlen(guionBajo)-1);
	}
	else{
	if(strcmp(tipoSimbolo,"CONST_REAL") == 0){
		sprintf(valor,"%f",valorFloat);
		if(existeCTE(strcat(guionBajo,valor))!=0)
			fprintf(archTS2,"%-30s%-30s%-30s%02d\n",guionBajo,tipoSimbolo,valor,strlen(guionBajo)-1);
	}
	else{
	 if(strcmp(tipoSimbolo,"CONST_STR") == 0)
		if(existeCTE(strcat(guionBajo,valorString))!=0)
			fprintf(archTS2,"%-30s%-30s%-30s%02d\n",guionBajo,tipoSimbolo,valorString,strlen(guionBajo)-1);
	}}}

	fclose(archTS2);

}


