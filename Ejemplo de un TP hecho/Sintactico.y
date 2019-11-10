%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"
extern int yylineno;
extern char *yytext;
extern YYSTYPE yylval;
int yystopparser=0;
FILE  *yyin;
//tabla de simbolos
char tituloTS[] = "NOMBRE                        TIPO                          VALOR                         LONGITUD\n";
char cabeceraFinal[] = ".MODEL LARGE\n.386\n.STACK 200h\n\nMAXTEXTSIZE equ 50\n\n.DATA\n\n\t";
void insertarEnTabla(char*,char*,char*,int,double);
//polaca
char vecPolaca[500][50];
int pilaPolaca[50];
int pilaWhile[50];
char pilaMult[500][50];
char * esWrite(char *prueba);
int posActual=0,tope=-1,topeW=-1,topeMult=-1;
char* insertarPolaca(char *);
char* obtenerComparador(char *);
void insertarPolacaInt(int);
void insertarPolacaDouble(double);
void insertarPolacaString(char *);
void avanzarPolaca();
void escribirPolaca();
char pilaASM[500][50];
char * esAsig(char *prueba);
void escribirPolacaInt();
void grabarPolaca();
void escribirTodoPolaca(int);
void guardarPos();
void intercambio();
void apilarMult(char *);
char* obtenerTopePilaMult();
int pedirPos();
void imprimirPolaca();
char cadAux[50];
char* ptr;
int topeASM=-1;
char *ptrMult;
char *ptrCadMult;
char auxBet[50],cadMult[50],msg[100];
int posAnt, pos2Ant;
int posWhile=0;
void generarAsm();
void desapilarASM();
void apilarASM();
char * esOperando(char * prueba,char * cmp);
void generarFMUL(FILE *final);
void generarFDIV(FILE *final);
void generarFSUB(FILE *final);
void generarFADD(FILE*);
void generarWRITE(FILE *final);
void generarASIG(FILE *final);
char paraApilar[20];
char topePila[50];
char topePila2[50];
// validaciones
int existeID(char *);
char ids[20][32];
int cantIds=0,i;
int existeCTE(char *);
void imprimirHeader(FILE *);
void imprimirVariables(FILE *);
int tipoElemento(char *);
struct sVariablesAsm{
	char tipo[30];
	char valor[50];
	char nombre[40];

};
typedef struct sVariablesAsm sVariablesAsm;
int indiceStruct;
sVariablesAsm vecStruct[200];
void generarCMP(FILE *,char *);
void generarSalto(FILE *,char *);
char vecSaltos [500][50];
int indiceVecSaltos=0;
void generarJMP(FILE *);
void insertarEtiquetaPolaca();
void generarCodigoEtiq(FILE * p,char * cad);
void generarBGE(FILE * p);
void generarBNE(FILE * p);
void generarBLE(FILE * p);
void generarBNE(FILE * p);
void generarBE(FILE * p);
void generarBLT(FILE * p);
void generarBGT(FILE * p);
void grabarSaltosEnArch(FILE * p);
char etiqSaltoWhile[30];
void insertarEtiquetaPolacaWhile();
%} 

%union {
int intval;
double val;
char *str_val;
}

%start PROGRAM
%token DECVAR ENDDEC BEGINP ENDP
%token REAL INTEGER STRING
%token IF ELSE WHILE
%token PUNTOYCOMA COMA DOSPTOS
%token OP_IGUAL OP_SUMA OP_RESTA OP_MULT OP_DIV
%token BETWEEN
%token C_A C_C P_A P_C LL_A LL_C
%token OP_COMPARACION_BLT OP_COMPARACION_BLE OP_COMPARACION_BGT OP_COMPARACION_BGE OP_COMPARACION_BEQ OP_COMPARACION_BNE
%token OP_LOG_AND OP_LOG_OR OP_LOG_NOT
%token WRITE READ
%token <str_val>ID
%token <int>CONST_INT
%token <str_val>CONST_STR
%token <double>CONST_REAL

%%
PROGRAM: 	est_declaracion algoritmo
		{printf("\nLa compilacion ha sido exitosa!!\r\n");}
		;

est_declaracion:
		DECVAR declaraciones ENDDEC
		;

declaraciones:
          	declaracion
          	| declaraciones declaracion
    	    	;

declaracion:
          	lista_var DOSPTOS REAL {for(i=0;i<cantIds;i++){insertarEnTabla(ids[i],"REAL","--",0,0);}cantIds=0;}
          	|lista_var DOSPTOS STRING {for(i=0;i<cantIds;i++){insertarEnTabla(ids[i],"STRING","--",0,0);}cantIds=0;}
          	|lista_var DOSPTOS INTEGER {for(i=0;i<cantIds;i++){insertarEnTabla(ids[i],"INTEGER","--",0,0);}cantIds=0;}
          	;
					
lista_var:
      	 	ID {
			strcpy(cadAux,yylval.str_val);
			ptr = strtok(cadAux," ,:");
			strcpy(ids[cantIds],ptr);
			cantIds++;
		   }
      	 	|ID COMA {
			strcpy(cadAux,yylval.str_val);
			ptr = strtok(cadAux," ,:");
			strcpy(ids[cantIds],ptr);
			cantIds++;
			} lista_var
       	 	;

algoritmo:
         	BEGINP bloque ENDP
         	;

bloque:
      		sentencia
      		|bloque sentencia
      		;

sentencia:
          	ciclo
      	 	|seleccion
      	 	|asignacion
      		|WRITE factor {insertarPolaca("WRITE");}
      		|READ factor {insertarPolaca("READ");}
          	;

ciclo:
          	WHILE {posWhile = posActual;insertarEtiquetaPolacaWhile();} P_A condicion P_C LL_A bloque LL_C {insertarPolaca("JMP");insertarPolaca(etiqSaltoWhile);
			
		insertarPolacaInt(posWhile);escribirTodoPolaca(posActual);insertarEtiquetaPolaca();}
          	;

asignacion:
        	ID OP_IGUAL expresion { 
					strcpy(cadAux,$1);
					ptr = strtok (cadAux," +-*/[](){}:=,\n");
					if(existeID(ptr)!=0){ 
					strcpy(msg,"El siguiente ID no esta declarado: ");
					yyerror(strcat(msg,ptr));
					}
					insertarPolaca(ptr);
					apilarMult(ptr);
					insertarPolaca(":=");
				      }
		| ID  OP_IGUAL asignacion { 
					strcpy(cadAux,$1);
					ptr = strtok (cadAux," +-*/[](){}:=,\n");
					if(existeID(ptr)!=0){ 
					strcpy(msg,"El siguiente ID no esta declarado: ");
					yyerror(strcat(msg,ptr));
					}
					ptrMult = obtenerTopePilaMult();
					insertarPolaca(ptrMult);
					insertarPolaca(ptr);
					insertarPolaca(":=");
				      }
	  	;


seleccion:
          	IF P_A condicion P_C LL_A bloque LL_C {		escribirTodoPolaca(posActual);insertarEtiquetaPolaca(); }
		
		|IF P_A condicion P_C LL_A bloque LL_C ELSE {insertarPolaca("JMP"); escribirTodoPolaca(posActual + 1); 
		guardarPos();insertarEtiquetaPolaca();}  LL_A  bloque LL_C 
		{ 
		escribirTodoPolaca(posActual);insertarEtiquetaPolaca();}
		
		|IF P_A condicion P_C LL_A LL_C {escribirTodoPolaca(posActual);insertarEtiquetaPolaca();}
		
		|IF P_A condicion P_C LL_A LL_C ELSE {insertarPolaca("JMP"); escribirTodoPolaca(posActual + 1); 
		guardarPos();insertarEtiquetaPolaca();} LL_A bloque LL_C {escribirTodoPolaca(posActual);insertarEtiquetaPolaca();}
		;

condicion:
         	comparacion 
         	|comparacion OP_LOG_AND comparacion 
         	|comparacion OP_LOG_OR {intercambio(); posAnt = pedirPos(); pos2Ant = pedirPos(); 
		if(pos2Ant!=-1){
			itoa(posActual, cadAux, 10);
				char aux [40]="ETIQUETA_SALTO_";
				strcat(aux,cadAux); 
			strcpy(vecPolaca[pos2Ant],aux); insertarEtiquetaPolaca();
			}} comparacion {itoa(posActual, cadAux, 10); char aux [40]="ETIQUETA_SALTO_"; strcat(aux,cadAux);
			strcpy(vecPolaca[posAnt],aux);insertarEtiquetaPolaca();}
         	
		| OP_LOG_NOT comparacion {intercambio();}
          	;

comparacion:
  	    	expresion OP_COMPARACION_BLE expresion {		
		insertarPolaca("FCOMP"); insertarPolaca("BLE"); guardarPos();}
          	
		|expresion OP_COMPARACION_BLT expresion { 				
		insertarPolaca("FCOMP"); insertarPolaca("BLT"); guardarPos();}
          	
		|expresion OP_COMPARACION_BGE expresion { 		
		insertarPolaca("FCOMP"); insertarPolaca("BGE"); guardarPos();}
          	
		|expresion OP_COMPARACION_BGT expresion { 		
		insertarPolaca("FCOMP"); insertarPolaca("BGT"); guardarPos();}
          	
		|expresion OP_COMPARACION_BEQ expresion {		
		insertarPolaca("FCOMP"); insertarPolaca("BEQ"); guardarPos();}
          	
		|expresion OP_COMPARACION_BNE expresion {		
		insertarPolaca("FCOMP"); insertarPolaca("BNE"); guardarPos();}
          	
		|between {}          	
          	;

between: 
          	BETWEEN P_A idBetween COMA C_A expresionBetween {insertarPolaca("FCOMP"); insertarPolaca("BLT"); guardarPos();} PUNTOYCOMA 		
		{insertarPolaca(auxBet);} expresionBetween {insertarPolaca("FCOMP"); insertarPolaca("BGT"); guardarPos();} C_C P_C 
          	;

expresion:   	
      	 	expresion OP_SUMA termino {insertarPolaca("FADDP");}
      	 	|expresion OP_RESTA termino {insertarPolaca("FSUB");}
		|termino 
       	 	;

termino:
      		termino OP_MULT factor {insertarPolaca("FMUL");}
       		|termino OP_DIV factor {insertarPolaca("FDIV");}
		|factor
       		;

factor:
      		ID 	{ 
			strcpy(cadAux,$1);
			ptr = strtok(cadAux," +-*/[](){}:=,\n");
			 if(existeID(ptr)!=0){ 
					strcpy(msg,"El siguiente ID no esta declarado: ");
					yyerror(strcat(msg,ptr));
					}
			insertarPolaca(ptr);
			}
      		|CONST_INT {insertarPolacaInt($<intval>1);}
      		|CONST_REAL {$<val>$ = $<val>1; insertarPolacaDouble($<val>$);}
      		|CONST_STR {$<str_val>$ = $<str_val>1; insertarPolacaString($1);}
          	|P_A expresion P_C  
      		;

expresionBetween:
         	 terminoBetween 
          	|expresionBetween OP_SUMA terminoBetween {insertarPolaca("FADDP");} 
          	|expresionBetween OP_RESTA terminoBetween {insertarPolaca("FSUB");} 
          	;

terminoBetween: 
          	factorBetween  
          	|terminoBetween OP_MULT factorBetween {insertarPolaca("FMUL");} 
          	|terminoBetween OP_DIV factorBetween {insertarPolaca("FDIV");} 
          	;

factorBetween: 
          	ID {$<str_val>$ = $<str_val>1;			
          	strcpy(cadAux,$1);
			ptr = strtok (cadAux," +-*/[](){}:=,\n");
			if(existeID(ptr)!=0){ 
					strcpy(msg,"El siguiente ID no esta declarado: ");
					yyerror(strcat(msg,ptr));
					}
			insertarPolaca(ptr);} 
          	|CONST_INT {insertarPolacaInt($<intval>1);}
          	|CONST_REAL {$<val>$ = $<val>1; insertarPolacaDouble($<val>$);}
          	|P_A expresionBetween P_C
          	;

idBetween:
		ID {
			$<str_val>$ = $<str_val>1;			
          		strcpy(cadAux,$1);
			ptr = strtok (cadAux," +-*/[](){}:=,\n");
			if(existeID(ptr)!=0){ 
				strcpy(msg,"El siguiente ID no esta declarado: ");
				yyerror(strcat(msg,ptr));
				}
			strcpy(auxBet,insertarPolaca(ptr)); }
		;

%%
int main(int argc,char *argv[])
{
  FILE *archTS;

  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	   printf("\r\nNo se puede abrir el archivo de prueba: %s\r\n", argv[1]);
	   return -1;
  }
  else
  {
	if ((archTS = fopen("ts.txt","wt")) == NULL){
		printf("\r\nNo se pudo crear la tabla de simbolos\r\n");
	   	return -2;
	}
	else{
	fwrite(tituloTS,sizeof(char), sizeof(tituloTS)-1, archTS);
    	fclose(archTS);
	}
    yyparse();
    fclose(yyin);

  }
  
	//puts("\n\n ******Vector de polaca:*****\r\n ");
	//imprimirPolaca();
	grabarPolaca();
	generarAsm();
  return 0;
}

int yyerror(char *msg){
    fprintf(stderr, "%s\n",msg);
    system("Pause");
    exit(1);
}

void apilarMult(char * cad){
	topeMult++; // topeMult=-1 significa pila vac�a, el primer elemento de la pila esta en tope=0
	strcpy(pilaMult[topeMult],cad);
}
char* obtenerTopePilaMult(){
	strcpy(cadMult,pilaMult[topeMult]);
	ptrCadMult = cadMult;
	return ptrCadMult;
}

char* insertarPolaca(char * cad){
	strcpy(vecPolaca[posActual],cad);
	posActual++;
	return cad;
}

void insertarPolacaInt(int entero){
	char cad[20];
	itoa(entero, cad, 10);
	insertarPolaca(cad);
}
void insertarPolacaDouble(double real){
	char cad[20];
	int i;
	sprintf(cad,"%.10f", real);
	insertarPolaca(cad);
}
void insertarPolacaString(char *cad){
	int i;
	
	insertarPolaca(cad);
}

void imprimirPolaca(){
	int i;
	for (i=0;i<posActual;i++){
	printf("posActual: %d, valor: %s \r\n",i,vecPolaca[i]);
	}

}

void grabarPolaca(){
  FILE* pf = fopen("intermedia.txt","wt");
  int i;
  fprintf(pf,"\r\n");
	for (i=0;i<posActual;i++){
	fprintf(pf,"%s\r\n",vecPolaca[i]);
	}
	fclose(pf);
}
void escribirPolaca(char * cad){
	int pedido=pedirPos();
	char aux [40]="ETIQUETA_SALTO_";
	strcat(aux,cad);
	strcpy(vecPolaca[pedido],aux);
	//strcat(vecPolaca[pedido],"ETIQUETA_SALTO_");
}
void escribirTodoPolaca(int num){
	char c[20];
	while(tope>=0){
		escribirPolacaInt(num);	
	}
}
void escribirPolacaInt(int num){
	char cad[20];
	itoa(num, cad, 10);
	escribirPolaca(cad);
}
void guardarPos(){
	tope++; // tope=-1 significa pila vac�a, el primer elemento de la pila esta en tope=0
	pilaPolaca[tope]=posActual;
	posActual++;
}
int pedirPos(){
	if(tope>-1){
	int retorno = pilaPolaca[tope];
	tope--;
	return retorno;
	}
	else{
	return -1;
	}
}
void guardarPosWhile(){
	topeW++; // tope=-1 significa pila vac�a, el primer elemento de la pila esta en tope=0
	pilaWhile[topeW]=posActual;
	posActual++;
}
int pedirPosWhile(){
	int retorno = pilaWhile[topeW];
	topeW--;
	return retorno;
}
void escribirPolacaWhile(int num){
	int pedido=pedirPosWhile();
	char cad[20];
	itoa(pedido, cad, 10);
	strcpy(vecPolaca[num],cad);
}
void intercambio(){
	char branch [5];
	strcpy(branch,vecPolaca[posActual - 2]);
	if(strcmp(branch, "BGE") == 0){
		strcpy(vecPolaca[posActual - 2], "BLT");
		return;
	}
	if(strcmp(branch, "BLT") == 0){
		strcpy(vecPolaca[posActual - 2], "BGE");
		return;
	}
	if(strcmp(branch, "BLE") == 0){
		strcpy(vecPolaca[posActual - 2], "BGT");
		return;
	}
	if(strcmp(branch, "BGT") == 0){
		strcpy(vecPolaca[posActual - 2], "BLE");
		return;
	}
	if(strcmp(branch, "BEQ") == 0){
		strcpy(vecPolaca[posActual - 2], "BNE");
		return;
	}
	if(strcmp(branch, "BNE") == 0){
		strcpy(vecPolaca[posActual - 2], "BEQ");
		return;
	}
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
	char nombreCad[20];
	int i,j;

	if(strcmp(tipoSimbolo,"REAL")==0 || strcmp(tipoSimbolo,"INTEGER")==0 || strcmp(tipoSimbolo,"STRING")==0)
		fprintf(archTS2,"%-30s%-30s%-30s%02d\n",nombreSimbolo,tipoSimbolo,"--",strlen(nombreSimbolo));
	else{
	
	if(strcmp(tipoSimbolo,"CONST_INT") == 0){
		sprintf(valor,"%d",valorInteger);
		if(existeCTE(strcat(guionBajo,valor))!=0){
			fprintf(archTS2,"%-30s%-30s%-30s%02d\n",guionBajo,tipoSimbolo,valor,strlen(guionBajo)-1);
		}
	}
	else{
	if(strcmp(tipoSimbolo,"CONST_REAL") == 0){
		sprintf(valor,"%.10f",valorFloat);
		if(existeCTE(strcat(guionBajo,valor))!=0){
			for (i=0;i<strlen(guionBajo);i++){
			    if (guionBajo[i] == '.'){
			       guionBajo[i] = '_';
				}
			}	
			fprintf(archTS2,"%-30s%-30s%-30s%02d\n",guionBajo,tipoSimbolo,valor,strlen(guionBajo)-1);
		}
	}
	else{
	 if(strcmp(tipoSimbolo,"CONST_STR") == 0)
		if(existeCTE(strcat(guionBajo,valorString))!=0){
			for (i=0;i<strlen(guionBajo);i++){
			    if (guionBajo[i] == '\'' || guionBajo[i] == ' '){
			       guionBajo[i] = '_';
				}
			}
			for (j=0;j<strlen(valorString);j++){
			    if (valorString[j] == ' '){
			       valorString[j] = '_';
				}
			}
			fprintf(archTS2,"%-30s%-30s%-30s%02d\n",guionBajo,tipoSimbolo,valorString,strlen(guionBajo)-1);
		}
	}}}

	fclose(archTS2);

}
void imprimirHeader(FILE *p){
	

    fprintf(p,"include macros2.asm\ninclude number.asm\n ");

    fprintf(p,".MODEL LARGE\n.386\n.STACK 200h\nMAXTEXTSIZE equ 50\n \n.DATA\n\n.DATA\n");
    
}

 void imprimirVariables(FILE * p){ 
	FILE * TS;
	char linea[1000];
	char id[50];
	char tipo[30];
	char valor[50];
	char aux[500];
	char tipoAsm[30];
	char auxCteStr [50]="\"";
	char* aux2;
	int tam,j;
	char* punto;
	char g = '.';
	sVariablesAsm structAInsertar;
	
	TS=fopen("ts.txt","rt");
	indiceStruct=0;
	fscanf(TS,"%30s%30s%30s%s\n",id,tipo,valor,aux);
	while(fscanf(TS,"%30s%30s%30s%02d\n",id,tipo,valor,&tam) == 4){
		if(strcmp(valor,"--")==0 && strcmp(tipo,"CONST_STR")!=0){//es una variable
			strcpy(valor,"?");
		}
		if(strcmp(tipo,"STRING")==0){
			strcpy(tipoAsm,"db");
		}else if(strcmp(tipo,"CONST_STR")==0){ 
			strcpy(tipoAsm,"db");
			strcpy(auxCteStr,valor);
			for (j=0;j<strlen(auxCteStr);j++){
			    if (auxCteStr[j] == '_'){
			       auxCteStr[j] = ' ';
				}
			}
			strcat(auxCteStr,"\", \"$\"");
			strcpy(valor,auxCteStr);
			aux2=strrchr(valor,'\'');
			*aux2='"';
			*(aux2+1)='\0';
			aux2=strchr(valor,'\'');
			*aux2='"';
			strcpy(valor,aux2);
			strcat(valor,", \"$\"");
		}else{
			strcpy(tipoAsm,"dd");
		} 
		strcpy(structAInsertar.nombre,id);
		strcpy(structAInsertar.tipo,tipo);
		strcpy(structAInsertar.valor,valor);
		vecStruct[indiceStruct]=structAInsertar;
		indiceStruct++;
		if(strcmp("CONST_STR", tipo) != 0 && strcmp("CONST_INT", tipo) != 0 && strcmp("CONST_REAL", tipo) != 0){
			fprintf(p,"_%s %s %s\n",id, tipoAsm ,valor);
		}else{
			fprintf(p,"%s %s %s\n",id, tipoAsm ,valor);
		}
	}	
			fprintf(p,"_@AUX dd ?\n");
		    fprintf(p, "\n.CODE\nSTART:\n");
		    fprintf(p, "mov AX,@data\nmov DS,AX\nmov ES, AX\n");

	/*
    fprintf(p, "\n;Declaracion de variables de usuario\n");
    fprintf(p, "\t@%s\tdd\t?\n", "a");
    fprintf(p, "\t_%s\tdd\t%s\n", "10","10.0");
    fprintf(p, "\t@%s\tdd\t?\n", "b");
    fprintf(p, "\t_%s\tdd\t%s\n", "20","20.0");*/
	fclose(TS);
	int i=0;
}
void generarAsm(){
	FILE *pf = fopen("intermedia.txt","rt");
	
	FILE *archTS3 = fopen("ts.txt","rt");
	FILE *final = fopen("Final.asm","wt");
	
	
	char linea[50];
	char cmp[10]="FCOMP";

	
	if (archTS3 == NULL){
		printf("\r\nNo se pudo abrir el archivo de la tabla de simbolos\r\n");
		return;
	}

	

	if (final == NULL){
		printf("\r\nNo se pudo abrir el archivo Final\r\n");
		return;
	}
	
	imprimirHeader(final);
	imprimirVariables(final);
	fclose(archTS3);
	

	if (pf == NULL){
		printf("\r\nNo se pudo abrir el archivo de polaca\r\n");
		return;
	}

	fgets(linea,sizeof(linea),pf);

	while(fgets(linea,sizeof(linea),pf)!=NULL)
	{
		strcpy(paraApilar,strtok(linea,"\r\n"));
			if( strcmp(paraApilar,"FADDP") == 0 )
        generarFADD(final);
      else
        if( strcmp(paraApilar,"FMUL") == 0 )
            generarFMUL(final);
        else
          if( strcmp(paraApilar,"FSUB") == 0 )
            generarFSUB(final);
          else
            if( strcmp(paraApilar,"FDIV") == 0 )
              generarFDIV(final);
            else
                if( strcmp(paraApilar,":=") == 0 )
                  generarASIG(final);
                else
                  if( strcmp(paraApilar,"WRITE") == 0 )
                    generarWRITE(final);
                  else
                        if( strcmp(linea,"FCOMP")==0)
                            generarCMP(final,linea);
							else
							 if( strcmp(linea,"BGE")==0)
                            generarBGE(final);
							else
							if( strcmp(linea,"BGT")==0)
                            generarBGT(final);
							else
							 if( strcmp(linea,"BLE")==0)
                            generarBLE(final);
							else
							 if( strcmp(linea,"BEQ")==0)
                            generarBE(final);
							else
							 if( strcmp(linea,"BNE")==0)
                            generarBNE(final);
							else
							if( strcmp(linea,"BLT")==0)
                            generarBLT(final);
							else
							if(strstr(linea,":"))
							generarCodigoEtiq(final,linea);
							else
							if(strstr(linea,"ETIQUETA_SALTO_")&&strstr(linea,":")==NULL)
							generarSalto(final,linea);
							else
                        if (strcmp(linea, "JMP")==0)
                            generarJMP(final);
                                else
                                    apilarASM(paraApilar);
	}

	fclose(pf);
	grabarSaltosEnArch(final);

	fprintf(final,"mov ah,4ch\n" );
    fprintf(final,"mov al,0\n" );
    fprintf(final,"int 21h\n" );

	fprintf(final,"\nSTRLEN PROC NEAR\n");
	fprintf(final,"\tmov BX,0\n");
	fprintf(final,"\nSTRL01:\n");
	fprintf(final,"\tcmp BYTE PTR [SI+BX],'$'\n");
	fprintf(final,"\tje STREND\n");
	fprintf(final,"\tinc BX\n");
	fprintf(final,"\tjmp STRL01\n");
	fprintf(final,"\nSTREND:\n");
	fprintf(final,"\tret\n");
	fprintf(final,"\nSTRLEN ENDP\n");
	fprintf(final,"\nCOPIAR PROC NEAR\n");
	fprintf(final,"\tcall STRLEN\n");
	fprintf(final,"\tcmp BX,MAXTEXTSIZE\n");
	fprintf(final,"\tjle COPIARSIZEOK\n");
	fprintf(final,"\tmov BX,MAXTEXTSIZE\n");
	fprintf(final,"\nCOPIARSIZEOK:\n");
	fprintf(final,"\tmov CX,BX\n");
	fprintf(final,"\tcld\n");
	fprintf(final,"\trep movsb\n");
	fprintf(final,"\tmov al,'$'\n");
	fprintf(final,"\tmov BYTE PTR [DI],al\n");
	fprintf(final,"\tret\n");
	fprintf(final,"\nCOPIAR ENDP\n");

	fprintf(final,"\nEND START\n");
	fclose(final);
}
void generarCodigoEtiq(FILE * p,char * cad){
	fprintf(p,"%s\n",cad);
}
void apilarASM(char* cad){
	topeASM++;
	strcpy(pilaASM[topeASM], cad);
}
void desapilarASM(char* cad){
	strcpy(cad, pilaASM[topeASM]);
	topeASM--;
}
void generarFADD(FILE * final){
	int tipo;
	desapilarASM(topePila);
	desapilarASM(topePila2);

	tipo=tipoElemento(topePila);
	if(tipo==1 || tipo==4){
		fprintf(final, "FILD _%s\n", topePila);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila);i++){
				if (topePila[i] == '.'){
					topePila[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila);
		}else{
			for (i=0;i<strlen(topePila);i++){
				if (topePila[i] == '.'){
					topePila[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila);
		}
	}

	tipo=tipoElemento(topePila2);
	if(tipo==1 || tipo==4){
		fprintf(final, "FILD _%s\n", topePila2);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila2);i++){
				if (topePila2[i] == '.'){
					topePila2[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila2);
		}else{
			for (i=0;i<strlen(topePila2);i++){
				if (topePila2[i] == '.'){
					topePila2[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila2);
		}
	}

	fprintf(final, "%s\n", paraApilar);
	fprintf(final, "FSTP _@AUX\n");	
	apilarASM("@AUX");
}
void generarFSUB(FILE * final){
	int tipo;
	desapilarASM(topePila);
	desapilarASM(topePila2);
	
	tipo=tipoElemento(topePila);
	if(tipo==1 || tipo==4){
		fprintf(final, "FILD _%s\n", topePila);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila);i++){
				if (topePila[i] == '.'){
					topePila[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila);
		}else{
			for (i=0;i<strlen(topePila);i++){
				if (topePila[i] == '.'){
					topePila[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila);
		}
	}

	tipo=tipoElemento(topePila2);
	if(tipo==1 || tipo==4){
		fprintf(final, "FILD _%s\n", topePila2);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila2);i++){
				if (topePila2[i] == '.'){
					topePila2[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila2);
		}else{
			for (i=0;i<strlen(topePila2);i++){
				if (topePila2[i] == '.'){
					topePila2[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila2);
		}
	}

	fprintf(final, "FSUB St(0),St(1)\n");
	fprintf(final, "FSTP _@AUX\n");	
	apilarASM("@AUX");
}
void generarFDIV(FILE *final){
	int tipo;
	desapilarASM(topePila);
	desapilarASM(topePila2);

	tipo=tipoElemento(topePila2);
	if(tipo==1 || tipo==4){
		fprintf(final, "FILD _%s\n", topePila2);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila2);i++){
				if (topePila2[i] == '.'){
					topePila2[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila2);
		}else{
			for (i=0;i<strlen(topePila2);i++){
				if (topePila2[i] == '.'){
					topePila2[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila2);
		}
	}

	tipo=tipoElemento(topePila);
	if(tipo==1 || tipo==4){
		fprintf(final, "FIDIV _%s\n", topePila);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila);i++){
				if (topePila[i] == '.'){
					topePila[i] = '_';
				}
			}
			fprintf(final, "FDIV _%s\n", topePila);
		}else{
			for (i=0;i<strlen(topePila);i++){
				if (topePila[i] == '.'){
					topePila[i] = '_';
				}
			}
			fprintf(final, "FDIV _%s\n", topePila);
		}
	}

	fprintf(final, "FSTP _@AUX\n");	
	apilarASM("@AUX");
}

void generarFMUL(FILE *final){
	int tipo;
	desapilarASM(topePila);
	desapilarASM(topePila2);

	tipo=tipoElemento(topePila2);
	if(tipo==1 || tipo==4){
		fprintf(final, "FILD _%s\n", topePila2);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila2);i++){
				if (topePila2[i] == '.'){
					topePila2[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila2);
		}else{
			for (i=0;i<strlen(topePila2);i++){
				if (topePila2[i] == '.'){
					topePila2[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila2);
		}
	}

	tipo=tipoElemento(topePila);
	if(tipo==1 || tipo==4){
		fprintf(final, "FIMUL _%s\n", topePila);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila);i++){
				if (topePila[i] == '.'){
					topePila[i] = '_';
				}
			}
			fprintf(final, "FMUL _%s\n", topePila);
		}else{
			for (i=0;i<strlen(topePila);i++){
				if (topePila[i] == '.'){
					topePila[i] = '_';
				}
			}
			fprintf(final, "FMUL _%s\n", topePila);
		}
	}

	fprintf(final, "FSTP _@AUX\n");	
	apilarASM("@AUX");
}
void generarWRITE(FILE *final){
	int tipo;
	desapilarASM(topePila);

	tipo=tipoElemento(topePila);
	if(tipo==1 || tipo==4){
		fprintf(final, "displayInteger _%s\n", topePila);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila);i++){
				if (topePila[i] == '.'){
					topePila[i] = '_';
				}
			}
			fprintf(final, "displayFloat _%s, 2\n", topePila);
		}else{
			if(tipo==3 || tipo==6){
				for (i=0;i<strlen(topePila);i++){
					if (topePila[i] == '\''){
						topePila[i] = '_';
					}
				}
				fprintf(final, "displayString _%s\n", topePila);
			}
		}
	}
	fprintf(final, "NEWLINE\n");
}
void generarASIG(FILE *final){
	int tipo;
	desapilarASM(topePila);
	desapilarASM(topePila2);

	tipo=tipoElemento(topePila2);
	if(tipo==1 || tipo==4){
		fprintf(final, "FILD _%s\n", topePila2);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila2);i++){
				if (topePila2[i] == '.'){
					topePila2[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila2);
		}else{
			if(tipo==3 || tipo==6){
				for (i=0;i<strlen(topePila2);i++){
					if (topePila2[i] == '\''){
						topePila2[i] = '_';
					}
				}
				fprintf(final, "MOV SI,OFFSET _%s\n", topePila2);
			}else{ 
				for (i=0;i<strlen(topePila2);i++){
					if (topePila2[i] == '.'){
						topePila2[i] = '_';
					}
				}
				fprintf(final, "FLD _%s\n", topePila2);
			}
		}
	}
	tipo=tipoElemento(topePila);
	if(tipo==1 || tipo==4){
		fprintf(final, "FISTP _%s\n", topePila);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila);i++){
				if (topePila[i] == '.'){
					topePila[i] = '_';
				}
			}
			fprintf(final, "FSTP _%s\n", topePila);
		}else{
			if(tipo==3 || tipo==6){
				for (i=0;i<strlen(topePila);i++){
					if (topePila[i] == '\''){
						topePila[i] = '_';
					}
				}
				fprintf(final, "MOV DI,OFFSET _%s\n", topePila);
				fprintf(final, "CALL COPIAR\n"); 
			}else{
				for (i=0;i<strlen(topePila);i++){
					if (topePila[i] == '.'){
						topePila[i] = '_';
					}
				}
				fprintf(final, "FSTP _%s\n", topePila);
			}
		}
	}	
}
char * esAsig(char *prueba){
	if(strcmp(prueba, ":=") == 0)
		return prueba;
	return NULL;
}
char * esWrite(char *prueba){
	if(strcmp(prueba, "WRITE") == 0)
		return prueba;
	return NULL;
}
void generarCMP(FILE * final,char * linea){
	char comparador[7];
	int tipo;
	desapilarASM(topePila);
	desapilarASM(topePila2);

	tipo=tipoElemento(topePila2);
	if(tipo==1 || tipo==4){
		fprintf(final, "FILD _%s\n", topePila2);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila2);i++){
				if (topePila2[i] == '.'){
					topePila2[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila2);
		}else{
			for (i=0;i<strlen(topePila2);i++){
				if (topePila2[i] == '.'){
					topePila2[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila2);
		}
	}
	tipo=tipoElemento(topePila);
	if(tipo==1 || tipo==4){
		fprintf(final, "FILD _%s\n", topePila);
	}else{
		if(tipo==2 || tipo==5){
			for (i=0;i<strlen(topePila);i++){
				if (topePila[i] == '.'){
					topePila[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila);
		}else{
			for (i=0;i<strlen(topePila);i++){
				if (topePila[i] == '.'){
					topePila[i] = '_';
				}
			}
			fprintf(final, "FLD _%s\n", topePila);
		}
	}
	fprintf(final, "FXCH \nFCOMP \nfstsw ax\nsahf\n");	


}
void generarJMP(FILE * final){
fprintf(final,"JMP ");
}
void generarSalto(FILE * p,char * linea){
	//guardo los saltos en el vec y desp los inserto
	/*char cadAux[50];
	strcpy(cadAux,linea);
	strcat(cadAux,":");
	strcpy(vecSaltos[indiceVecSaltos],cadAux);
	indiceVecSaltos++;*/

	fprintf(p,"%s\n",linea);	
}
void grabarSaltosEnArch(FILE * p){
	int i=0;
	while(i<indiceVecSaltos){
	fprintf(p,"\n%s\n",vecSaltos[i]);
	i++;
	}
}
void insertarEtiquetaPolaca(){
	char aux [30]="ETIQUETA_SALTO_";
	char aux2[20];
	itoa(posActual,aux2,10);
	strcat(aux,aux2);
	strcat(aux,":");
	insertarPolaca(aux);
}
void insertarEtiquetaPolacaWhile(){
	char aux [30]="ETIQUETA_SALTO_";
	//etiqSaltoWhile[0]=' ';
	char aux2[20];
	itoa(posActual,aux2,10);
	strcat(aux,aux2);
	strcpy(etiqSaltoWhile,aux);
	strcat(aux,":");
	insertarPolaca(aux);
}
int tipoElemento(char *elemento){

	//valores del return
	//1: Constante entera
	//2: Constante real
	//3: Constante string
	//4: Variable entera
	//5: Variable real
	//6: Variable string
	//-1: Error, no fue encntrado

	FILE * TS;
	char id[50];
	char tipo[30];
	char valor[50];
	char aux[500];
	int tam;
	TS=fopen("ts.txt","rt");

	fscanf(TS,"%30s%30s%30s%s\n",id,tipo,valor,aux);

	while(fscanf(TS,"%30s%30s%30s%02d\n",id,tipo,valor,&tam)==4){
		if(strcmp(valor,elemento)==0){//es una constante
			if(strcmp(tipo,"CONST_INT")==0){
				return 1;
			}else{
				if(strcmp(tipo,"CONST_REAL")==0){
					return 2;
				}else{
					if(strcmp(tipo,"CONST_STR")==0){
						return 3;
					}
				}
			}
		}else{
			if(strcmp(valor,"--")==0){//es una variable
				if(strcmp(id,elemento)==0){
					if(strcmp(tipo,"INTEGER")==0){
						return 4;
					}else{
						if(strcmp(tipo,"REAL")==0){
							return 5;
						}else{
							if(strcmp(tipo,"STRING")==0){
								return 6;
							}
						}
					}
				}
			}
		}

	}
	fclose(TS);
	return -1;
}

void generarBNE(FILE * p){	fprintf(p,"JNE ");
}
void generarBLE(FILE * p){	fprintf(p,"JNA ");
}
void generarBGE(FILE * p){	fprintf(p,"JNB ");
}
void generarBE(FILE * p){	fprintf(p,"JE ");
}
void generarBLT(FILE * p){	fprintf(p,"JNAE ");
}
void generarBGT(FILE * p){	fprintf(p,"JNBE ");
}
