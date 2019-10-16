LIST		p=16F887		; Tipo de microcontrolador
INCLUDE 	P16F887.INC		; Define los SFRs y bits

__CONFIG _CONFIG1, _CP_OFF&_WDT_OFF&_XT_OSC ; Ingresa parámetros de configuración
errorlevel	 -302	

 ;Definicion de variables
  cblock 0x20             ;Inicio de la RAM disponible
 COMPTE:1                ;Variable de un byte
 VARDEL1:1               ;Variable de un byte
 VARDEL2:1               ;Variable de un byte
 endc

 ;Comienza Programa
     org 00h             ;Vector de reset
     goto Start

 Start

     clrw                ;Limpia registro w (acumulador)
     movwf PORTB         ;Limpia registro PORTB
     bsf STATUS,RP0      ;Set bit RP0 (5) del registro STATUS (Acceso a bank 1)
     movwf TRISB         ;Declaramos como salida el Puerto B colocando 0 en el
     bcf STATUS,RP0      ;Clear bit RP0(5) del registro de STATUS (Acceso a bank 0)

     ;El bit RP0 (bit 5), junto con RP1 (bit 6), son para activar/desactivar Lectura y Escritura
     ;Recordar siempre colocar a 1 el bit PR0 de STATUS antes de modificar el modo (entrada/salida) de un puerto
     ;Y después, al acabar, colocarlo de nuevo en 0

 Init
     clrf COMPTE         ;Limpiamos la variable COMPTE

 IncCompte
     incf COMPTE,F       ;Incrementamos COMPTE y guardamos resultado en COMPTE, igual sería: incf COMPTE,1. En C dería algo como COMPTE++ o COMPTE = COMPTE +1
     movf COMPTE,W       ;Copiamos el valor de la variable COMPTE al acumulador W
     movwf PORTB         ;Copiamos el valor del acumulador W al puerto B
     call Delai          ;Entramos a la función delai
     goto IncCompte      ;Regresamos a incrementar el contador, una vez que este se desborde, es decir, sobrepase el byte, regresará a 0

 ;La función, si es que podemos llamarla función debido a que esto es assembler, de Delai, es crear un retardo de tiempo de unos cauntos milisengudos
 ;lo suficiente para ver cambiar los leds
 ;Si observamos bien la estructura de Delai, veremos que es algo así como un bucle for anidado dentro de otro.
 Delai
     movlw 0xFF          ;Copiamos una literal o constante al acumulador W, en este caso 0xFF
     movwf VARDEL2       ;Copiamos el registro del acumulador W a VARDEL2

 D0
     movwf VARDEL1      

 D1
     decfsz VARDEL1,F
     goto D1
     decfsz VARDEL2,F
     goto D0
     return

 end                     ;Fin del programa