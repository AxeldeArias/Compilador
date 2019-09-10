
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
%token ID COMENTARIO
%token CTE_E CTE_R CTE_S
%token OP_SUMA OP_RESTA OP_MUL OP_DIV ASIG P_A P_C
%token OP_I OP_D  
%token IF ELSE AND OR
%token L_A L_C
%token OP_MEN OP_MEN_IG OP_MAY OP_MAY_IG
%%
start : programa {printf("Compilación Finalizada\n");};
programa : programa sentencia ;
programa : sentencia  ;
sentencia : asignacion ;
sentencia : seleccion ;
sentencia: comentario;

asignacion: ID ASIG expresion ;

seleccion:  IF P_A comparacion P_C L_A programa L_C {printf("IF");};
seleccion:  IF P_A comparacion P_C L_A programa L_C
            ELSE L_A programa L_C{printf("IF");};
comparacion: simple | simple comparador simple ;
comparador: AND | OR;
operaciones_comparacion:  OP_MEN | OP_MEN_IG | OP_MAY | OP_MAY_IG | OP_D | OP_I  
simple : expresion operaciones_comparacion expresion ;


expresion:
        termino 
        |expresion OP_RESTA termino {printf("Resta\n");}
        |expresion OP_SUMA termino {printf("Suma\n");} 	 ;

termino: 
       factor
       |termino OP_MUL factor  {printf("Multiplicacion OK\n");}
       |termino OP_DIV factor  {printf("Division OK\n");}
       ;

factor: 
      ID 
      | CTE_E {$1 = yylval ;printf("CTE_E es: %d\n", yylval);}
      | CTE_R {$1 = yylval ;printf("CTE_R es: %f \n", yylval);}
      |P_A expresion P_C  
      ;
      
comentario:
  COMENTARIO {printf("Comentario\n");}

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




