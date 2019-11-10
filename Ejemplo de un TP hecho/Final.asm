include macros2.asm
include number.asm
 .MODEL LARGE
.386
.STACK 200h
MAXTEXTSIZE equ 50
 
.DATA

.DATA
_x dd ?
_w dd ?
_k dd ?
_y dd ?
_z dd ?
_l dd ?
_h db ?
_105_5400000000 dd 105.5400000000
_10 dd 10
_4_5000000000 dd 4.5000000000
_9 dd 9
_1 dd 1
_95 dd 95
_3_5000000000 dd 3.5000000000
__Else_ db "Else", "$"
_0 dd 0
_5 dd 5
_3 dd 3
_2 dd 2
__While_ db "While", "$"
__Mensaje_de_prueba_ db "Mensaje de prueba", "$"
_@AUX dd ?

.CODE
START:
mov AX,@data
mov DS,AX
mov ES, AX
FLD _105_5400000000
FSTP _w
FLD _w
FSTP _k
FLD _w
FISTP _l
displayInteger _l
NEWLINE
displayFloat _k, 2
NEWLINE
FILD _10
FISTP _z
FILD _9
FIMUL _1
FSTP _@AUX
FLD _@AUX
FLD _4_5000000000
FADDP
FSTP _@AUX
FILD _z
FLD _@AUX
FSUB St(0),St(1)
FSTP _@AUX
FLD _@AUX
FSTP _x
displayFloat _x, 2
NEWLINE
FILD _95
FISTP _y
FLD _x
FLD _3_5000000000
FXCH 
FCOMP 
fstsw ax
sahf
JNAE ETIQUETA_SALTO_39
displayInteger _y
NEWLINE
JMP ETIQUETA_SALTO_42
ETIQUETA_SALTO_39:
displayString __Else_
NEWLINE
ETIQUETA_SALTO_42:
ETIQUETA_SALTO_43:
FLD _x
FILD _0
FXCH 
FCOMP 
fstsw ax
sahf
JNAE ETIQUETA_SALTO_54
FLD _x
FILD _1
FXCH 
FCOMP 
fstsw ax
sahf
JNA ETIQUETA_SALTO_69
ETIQUETA_SALTO_54:
FILD _z
FILD _5
FXCH 
FCOMP 
fstsw ax
sahf
JNAE ETIQUETA_SALTO_80
FILD _3
FLD _x
FSUB St(0),St(1)
FSTP _@AUX
FILD _y
FMUL _@AUX
FSTP _@AUX
FILD _z
FLD _@AUX
FXCH 
FCOMP 
fstsw ax
sahf
JNBE ETIQUETA_SALTO_80
ETIQUETA_SALTO_69:
FILD _z
FIMUL _2
FSTP _@AUX
FLD _@AUX
FISTP _z
displayString __While_
NEWLINE
JMP ETIQUETA_SALTO_43
ETIQUETA_SALTO_80:
MOV SI,OFFSET __Mensaje_de_prueba_
MOV DI,OFFSET _h
CALL COPIAR
displayString _h
NEWLINE
mov ah,4ch
mov al,0
int 21h

STRLEN PROC NEAR
	mov BX,0

STRL01:
	cmp BYTE PTR [SI+BX],'$'
	je STREND
	inc BX
	jmp STRL01

STREND:
	ret

STRLEN ENDP

COPIAR PROC NEAR
	call STRLEN
	cmp BX,MAXTEXTSIZE
	jle COPIARSIZEOK
	mov BX,MAXTEXTSIZE

COPIARSIZEOK:
	mov CX,BX
	cld
	rep movsb
	mov al,'$'
	mov BYTE PTR [DI],al
	ret

COPIAR ENDP

END START
