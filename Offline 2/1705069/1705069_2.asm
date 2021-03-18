.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    UPPER DB 0H
    LOWER DB 0H
    DIGIT DB 0H
    MSG1 DB CR, LF, 'Valid password$'
    MSG2 DB CR, LF, 'Invalid password$'
    
.CODE
MAIN PROC
   ;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
   
   WHILE_:
    ;input
    MOV AH, 1
    INT 21H
   
        CHECK_OTHER:
            CMP AL, 21H
            JL END_WHILE
            CMP AL, 7EH
            JG END_WHILE
    
        CHECK_UPPER:
            CMP AL, 'A'
            JL CHECK_DIGIT
            CMP AL, 'Z'
            JG CHECK_LOWER
            MOV DL, 1H
            MOV UPPER, DL ;if upper, set UPPER TO 1
            JMP WHILE_
    
        CHECK_LOWER:
            CMP AL, 'a'
            JL CHECK_DIGIT
            CMP AL, 'z'
            JG CHECK_DIGIT
            MOV DL, 1H
            MOV LOWER, DL  ;if lower, set LOWER TO 1
            JMP WHILE_
        
        CHECK_DIGIT:
            CMP AL, '0'
            JL WHILE_
            CMP AL, '9'
            JG WHILE_
            MOV DL, 1H
            MOV DIGIT, DL
            JMP WHILE_    
       
   END_WHILE:
        CMP UPPER, 0H
        JE INVALID
        CMP LOWER, 0H
        JE INVALID
        CMP DIGIT, 0H
        JE INVALID
        JMP VALID
   VALID:
        LEA DX, MSG1
        JMP DISPLAY
    
   INVALID:
        LEA DX, MSG2
   
   DISPLAY:     
        MOV AH, 9
        INT 21H
   
   END:   
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H 
MAIN ENDP
    END MAIN
