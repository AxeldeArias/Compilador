%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>
#include <limits.h>
#include "y.tab.h"
FILE  *yyin;
void validarEntero(int);
void validarReal(double);
void validarString(char[]);
void validarId(char[]);
%}

%option noyywrap  
%option yylineno 

DIGITO			[0-9]
LETRA			[a-zA-Z]
BARRAENE 		["\n"]
PUNTOYCOMA              [";"]
COMA                    [","]
DOSPTOS			[":"]
espacio 		[" "]
menos       		[-]
caracter 		[a-z,A-Z,0-9]
noChar			["?","¿","!","¡","#","$","%","&","/","(",")",".",",",";"]
texto 			"'"({caracter}+|{espacio})*"'"
textoInvalido 		"'"({caracter}|{noChar}+)*"'"
COMENTARIOS             "-/"({LETRA}|{DIGITO}|{BARRAENE}|{espacio})+"/-"
CONST_REAL              ({menos}{DIGITO}*|{DIGITO}*)"."{DIGITO}*
CONST_INT               ({menos}{DIGITO}+|{DIGITO}+)
ID			{LETRA}({LETRA}|{DIGITO}|_)*
OP_COMPARACION_BLE  	[">"]  
OP_COMPARACION_BLT  	[">="]      
OP_COMPARACION_BGE  	["<"] 
OP_COMPARACION_BGT  	["<="] 
OP_COMPARACION_BEQ  	["<>"] 
OP_COMPARACION_BNE  	["=="] 
OP_SUMA                 ["+"]
OP_RESTA		["-"]
OP_MULT                 ["*"]
OP_DIV			["/"]
OP_IGUAL   		[":="]
OP_LOG_AND  		["and"]
OP_LOG_OR   		["or"]
OP_LOG_NOT  		["not"]           
C_A                     ["["]
C_C                     ["]"]
P_A                     ["("]
P_C                     [")"]
LL_A			["{"]
LL_C			["}"]

%%
"BETWEEN"		{ return BETWEEN;}
"DECVAR"		{ return DECVAR;}
"ENDDEC"		{ return ENDDEC;}
"beginp"		{ return BEGINP;}
"endp"			{ return ENDP;}
"real"			{ return REAL;}
"integer"		{ return INTEGER;}
"string"		{ return STRING;}
"if"			{ return IF;}
"else"   		{ return ELSE;}
"while"	      		{ return WHILE;}
";"			{ return PUNTOYCOMA;}
","			{ return COMA;}
":"			{ return DOSPTOS;}
":="			{ return OP_IGUAL;}
"+"			{ return OP_SUMA;}
"-"			{ return OP_RESTA;}
"*"			{ return OP_MULT;}
"/"			{ return OP_DIV;}
"["			{ return C_A;}
"]"			{ return C_C;}
"("			{ return P_A;}
")"			{ return P_C;}
"{"			{ return LL_A;}
"}"			{ return LL_C;}
">"                     { return OP_COMPARACION_BLE;}
">="                    { return OP_COMPARACION_BLT;}
"<"                     { return OP_COMPARACION_BGE;}
"<="                    { return OP_COMPARACION_BGT;}
"<>"                    { return OP_COMPARACION_BEQ;}
"=="                     { return OP_COMPARACION_BNE;}
"and"                   { return OP_LOG_AND;}
"or"                    { return OP_LOG_OR;}
"not"                   { return OP_LOG_NOT;}
"write"			{ return WRITE;}
"read"			{ return READ;}
{ID}			{ 
			yylval.str_val = yytext;
			return ID;
			}
{CONST_INT}		{
			yylval.intval = atoi(yytext);
			validarEntero(yylval.intval);				
			insertarEnTabla("","CONST_INT","--",yylval.intval,0);
			return CONST_INT;
			}
{texto}			{ 
			yylval.str_val = yytext;
			validarString(yylval.str_val); 
			insertarEnTabla(yylval.str_val,"CONST_STR",yylval.str_val,0,0);
			return CONST_STR;
			}
{CONST_REAL}		{
			yylval.val = atof(yytext);
			validarReal(yylval.val); 
			insertarEnTabla("","CONST_REAL","--",0,yylval.val);
			return CONST_REAL;
			}
{COMENTARIOS}	
{textoInvalido}		{ printf("Caracter invalido en String: %s \r\n", yytext);  exit(1);}

"\n"      		
"\t"		
%%

void validarEntero(int valor){
	if(valor < -32768 || valor > 32767){
		yyerror("Rango de entero excedido, el tipo de dato integer debe estar entre [-32768 y 32767]\r\n");
	}
}

void validarReal(double valor){
	valor=fabs(valor);
	if(valor<FLT_MIN || valor>FLT_MAX){
		yyerror("Rango de real excedido, el tipo de dato real debe estar entre [1.17549e-38 y 3.40282e38]\r\n");
	}
}

void validarString(char cadena[]){
	int valor=strlen(cadena);
	if(valor>32){
		yyerror("Rango de String excedido, el tipo de dato string debe tener como maximo 30 caracteres\r\n");
	}
}
void validarId(char cadena[]){
	int valor=strlen(cadena);
	if(valor>32){
		yyerror("Rango de ID excedido, el ID debe tener como maximo 30 caracteres\r\n");
	}
}
