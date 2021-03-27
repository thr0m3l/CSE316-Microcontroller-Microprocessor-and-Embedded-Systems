.MODEL SMALL
.STACK 100H

.DATA

    N DW ?
    COMMA DW ', $'   


.CODE

MAIN PROC
    
    MOV AX, @DATA
    MOV DS, AX
    
    CALL INDEC
    MOV N, AX ;saves N
    MOV DX, 1
    FOR:
        PUSH DX
        CALL FIB
        INC DX
        CALL OUTDEC
        CALL LINE
        CMP DX, N
        JLE FOR
        JG EXIT
    
    EXIT:
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP

FIB PROC
    PUSH BP ;saves BP
    
    MOV BP, SP ;stack top
    
    MOV AX, [BP+4] ;get N
    
    CMP AX, 1 ; N = 1 ?
    JE FIRST
    CMP AX, 2
    JE SECOND
    JMP REC
    
    FIRST:
        MOV AX, 0
        JMP RETURN
    SECOND:
        MOV AX, 1
        JMP RETURN
    
    REC:
    ;F(N-1)
    MOV CX, [BP+4]
    DEC CX
    PUSH CX ;Save N-1
    CALL FIB
    PUSH AX ;save result1
   
    ;F(N-2)
    MOV CX, [BP+4]
    SUB CX, 2
    PUSH CX ;save N-2
    CALL FIB ;result2 in AX
    
    
    ;F(N) = F(N-1) + F(N-2)
    
    POP BX ;get result1
    ADD AX, BX
    
    
    RETURN:
        POP BP
        RET 2
    
    
    
FIB ENDP

INDEC PROC
    ;takes multidigit integer as input
    ;INPUT: NONE
    ;OUTPUT: AX
    
    ;saves the registers on the stack
    PUSH BX
    PUSH CX
    PUSH DX
     
    ;resets BX, CX
    MOV BX, 0 ;BX = total
    MOV CX, 0 ;CX = sign, 1 if minus, 0 if plus
    
    ;Input from console
    MOV AH, 1
    
    
    @CHECK:
    INT 21H
    CMP AL, '-'
    JE @MINUS
    CMP AL, '0'
    JL @CHECK
    CMP AL, '9'
    JG @CHECK
    JMP @WHILE
    
    @MINUS:
        MOV CX, 1
        INT 21H
            
    @WHILE:
        
        CMP AL, 0DH
        JE @END_WHILE
        CMP AL, '0'
        JL @INPUT
        CMP AL, '9'
        JG @INPUT
        
        
        AND AX, 000FH ;converts to digit
        PUSH AX
        
        ;total = total*10 + digit
        MOV AX, 10
        MUL BX
        POP BX
        ADD BX, AX
        
        @INPUT:
        MOV AH, 1
        INT 21H
        JMP @WHILE
        
    @END_WHILE:
        CMP CX, 1
        JE @NEGATIVE
        JNE @EXIT
    @NEGATIVE:
    NEG BX
    @EXIT:
    MOV AX, BX
    
    ;restores the registers back to initial state
    POP DX
    POP CX
    POP BX
    RET
    
     
         
INDEC ENDP

OUTDEC PROC
    ;Outputs a signed decimal integer
    ;INPUT: AX
    ;OUTPUT: NONE
    
    
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH AX
    
    ;if AX < 0
    CMP AX, 0
    JGE @END_IF ;if AX >= 0
    ;then
    PUSH AX ;save AX
    MOV AH, 2
    MOV DL, '-'
    INT 21H
    
    POP AX ;get the number back from stack
    NEG AX ; AX = -AX 
    
    ;else
    @END_IF:
        MOV CX, 0 ;CX counts digits
        MOV BX, 10
    
    @WHILE1:
        MOV DX, 0 ; Dividend
        DIV BX ; Quo:Rem = AX:DX
        PUSH DX; Save rem on stack
        INC CX;
        
        CMP AX, 0 ; quo = 0?
        JNE @WHILE1
        
    MOV AH, 2
        
    @PRINT_LOOP:    
        POP DX
        ADD DL, 30H
        INT 21H
        LOOP @PRINT_LOOP
        
    ;exit
    POP AX
    POP DX
    POP CX
    POP BX
    RET   
    
OUTDEC ENDP

LINE PROC
    
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH AX  
   
    ;Linebreak
    
    LEA DX, COMMA
    MOV AH, 9
    INT 21H
    
    POP AX
    POP DX
    POP CX
    POP BX
    
    RET    
    
LINE ENDP


END MAIN