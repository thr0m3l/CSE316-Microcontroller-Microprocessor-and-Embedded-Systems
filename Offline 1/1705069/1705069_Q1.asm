.MODEL SMALL


.STACK 100H


.DATA
         
CR EQU 0DH
LF EQU 0AH

X DB ?
Y DB ?
TEMP DB ?

MSG1 DB 'X = $'
MSG2 DB CR, LF, 'Y = $'
MSG3 DB CR, LF, 'Z = X - 2Y = '
Z1 DB ?
MSG4 DB CR, LF, 'Z = 25 - (X + Y ) = '
Z2 DB ?
MSG5 DB CR, LF, 'Z = 2X - 3Y = '
Z3 DB ?
MSG6 DB CR, LF, 'Z = Y - X + 1 = '
Z4 DB ?, '$'
  


.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    ;Display Prompt
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    ;Input X
    MOV AH, 1
    INT 21H
    SUB AL, 30H
    MOV X, AL
    
    ;Display Prompt
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    
    ;Input Y
    MOV AH, 1
    INT 21H
    SUB AL, 30H
    MOV Y, AL
    
    ;Z = X - 2Y
    ADD AL, Y
    MOV TEMP, AL
    MOV AL, X
    SUB AL, TEMP
    ADD AL, 30H 
    MOV Z1, AL
    
    ;Z = 25 - (X + Y ) 
    MOV AL, X
    ADD AL, Y
    MOV TEMP, AL
    MOV AL, 25D
    SUB AL, TEMP
    ADD AL, 30H
    MOV Z2, AL
    
    ;Z = 2X - 3Y
    MOV AL, X
    ADD AL, X
    SUB AL, Y
    SUB AL, Y
    SUB AL, Y
    ADD AL, 30H
    MOV Z3, AL
    
    ;Z = Y - X + 1
    MOV AL, Y
    SUB AL, X
    ADD AL, 1D
    ADD AL, 30H
    MOV Z4, AL
    
    
    ;OUTPUT
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H
     
    
MAIN ENDP
END MAIN