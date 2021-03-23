.MODEL SMALL


.STACK 100H


.DATA
CR EQU 0DH
LF EQU 0AH

MSG1 DB 'ENTER A UPPERCASE LETTER: $'
MSG2 DB CR, LF, 'PREVIOUS LETTER IN LOWERCASE FORMAT: '
CHAR1 DB ?
MSG3 DB CR, LF, '1s COMPLEMENT: ' 
CHAR DB ?, '$'

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    ;Display Prompt
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    ;Q2.1 Input a character -> decrease by 1 -> Convert to Lowercase
    MOV AH, 1
    INT 21H
    MOV CHAR, AL
    DEC AL
    ADD AL, 20H
    MOV CHAR1, AL
    
    ;Q2.2 Negates the number then decreases by one
    NEG CHAR
    DEC CHAR
    
    
    
    ;Display answer on the next line
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
