.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH

    OP1 DW ?
    OP2 DW ?
    OPR DW ?
    LB DB CR, LF, '$'

.CODE
;DATA SEGMENT INITIALIZATION
    MAIN PROC
    
    MOV AX, @DATA
    MOV DS, AX
    
    ;Operand1 input
    CALL INDEC
    MOV OP1, AX
    
    ;Linebreak
    MOV AH, 9
    LEA DX, LB
    INT 21H
    
    ;Operator input
    MOV AH, 1
    INT 21H
    
    ;Linebreak
    MOV AH, 9
    LEA DX, LB
    INT 21H
    
    MOV AH, 0
    MOV OPR, AX
   
    
    ;Operand2 input
    CALL INDEC
    MOV OP2, AX
    
    ;Linebreak
    MOV AH, 9
    LEA DX, LB
    INT 21H
    
    MOV AX, OP1
    MOV BX, OP2
    MOV CX, OPR
    
    
    ;Performs operation
    CALL OP
    
    
    
    ;Output (AX)
    CALL OUTDEC
    
       
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H
    
    
MAIN ENDP
    
OP PROC
    ;INPUT: AX = Operand1
    ;       BX = Operand2
    ;       CX = Operator
    ;OUTPUT: AX
    
    CMP CX, '+'
    JE @ADDITION
    CMP CX, '-'
    JE @SUBTRACTION
    CMP CX, '*'
    JE @MULTIPLICATION
    CMP CX, '/'
    JE @DIVISION
    
    @ADDITION:
    ADD AX, BX
    JMP @END
    
    @SUBTRACTION:
    SUB AX, BX
    JMP @END
    
    @MULTIPLICATION:
    
    @DIVISION:
    
    @END:
        RET
    
    
    
OP ENDP    


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
    INT 21H
    
    @CHECK:
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
        JL @WHILE
        CMP AL, '9'
        JG @WHILE
        
        
        AND AX, 000FH ;converts to digit
        PUSH AX
        
        ;total = total*10 + digit
        MOV AX, 10
        MUL BX
        POP BX
        ADD BX, AX
        
        ;input
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
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;if AX < 0
    CMP AX, 0
    JGE @END_IF ;if AX >= 0
    ;then
    MOV AH, 2
    MOV DL, '-'
    INT 21H
    POP AX
    NEG AX ; AX = -AX 
    
    ;else
    @END_IF:
        MOV CX, 0 ;CX counts digits
        MOV BX, 10D
    
    @WHILE1:
        MOV DX, 0 ; Dividend
        DIV BX ; Quo:Rem = AX:DX
        PUSH DX; Save rem on stack
        INC CX;
        
        CMP AX, 0 ; quo = 0?
        JNE @WHILE1
        
        
    @PRINT_LOOP:    
        POP DX
        ADD DL, 30H
        MOV AH, 2
        INT 21H
        LOOP @PRINT_LOOP
    
    ;Linebreak
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H
        
    ;exit
    POP DX
    POP CX
    POP BX
    POP AX
    RET   
    
OUTDEC ENDP

    END MAIN