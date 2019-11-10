Profesor/a:

Queriamos comentarle que al querer ejecutar la generacion del codigo assembler y compilarlo, nos mostraba un error de que los ejecutables TASM.EXE y TLINK.EXE eran especificas para un sistema operativo de 64 bits. Por lo tanto, optamos por sacarlo del lotes.bat.
Ademas, agregamos al comprimido por dichos problemas los archivos Final.exe y Final.obj que fueron compilados en nuestras maquinas por el GUI Turbo Assembler.

Comando eliminados:
	TASM.EXE /zi Final.asm
	TASM.EXE /la numbers.asm
	TLINK.EXE /v Final

Mensajes de error:
	Esta versión de C:\Compilador\v3\TASM.EXE no es compatible con la versión de Windows que está ejecutando. Compruebe la información de sistema del equipo y después póngase en contacto con el anunciante de software.
	Esta versión de C:\Compilador\v3\TASM.EXE no es compatible con la versión de Windows que está ejecutando. Compruebe la información de sistema del equipo y después póngase en contacto con el anunciante de software.
	Esta versión de C:\Compilador\v3\TLINK.EXE no es compatible con la versión de Windows que está ejecutando. Compruebe la información de sistema del equipo y después póngase en contacto con el anunciante de software.

Sepa entendernos.
Muchas gracias.