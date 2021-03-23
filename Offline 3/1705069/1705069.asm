.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH

    OP1 DW ?
    OP2 DW ?
    OPR DW ?
    RESULT DW ?
    LB DB CR, LF, '$'
    ERR DB CR, LF, 'Wrong operator$'

.CODE
;DATA SEGMENT INITIALIZATION
MAIN PROC
    
    MOV AX, @DATA
    MOV DS, AX
    
    ;Operand1 input
    CALL INDEC
    MOV OP1, AX
    
    CALL LINE ;newline
    
    ;Operator input
    MOV AH, 1
    INT 21H
    
    MOV AH, 0
    MOV OPR, AX
    
    ;Operator validity check
    CMP AL, 'q'
    JE @DOS_EXIT
    CMP AL, '+'
    JE @OPR_OK
    CMP AL, '-'
    JE @OPR_OK
    CMP AL, '*'
    JE @OPR_OK
    CMP AL, '/'
    JE @OPR_OK
    
    LEA DX, ERR
    MOV AH, 9
    INT 21H
    JMP @DOS_EXIT ;operator is invalid, quit
    
    
    ;Operator is valid, proceed
    @OPR_OK:
    CALL LINE; newline
   
    ;Operand2 input
    CALL INDEC
    MOV OP2, AX
    
    CALL LINE
    
    MOV AX, OP1
    MOV BX, OP2
    MOV CX, OPR
    
    
    ;Performs operation
    CALL OP
    MOV RESULT, AX
    
    ;Output (AX)
    MOV AX, OP1
    CALL OUTDEC
    
    MOV DX, OPR
    MOV AH, 2
    INT 21H
    
    MOV AX, OP2
    CALL OUTDEC
    
    MOV DX, '='
    MOV AH, 2
    INT 21H
    
    MOV AX, RESULT
    CALL OUTDEC
    
    CALL LINE
       
    ;DOS EXIT
    @DOS_EXIT:
    MOV AH, 4CH
    INT 21H
        
MAIN ENDP
    
LINE PROC
    
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH AX  
   
    ;Linebreak
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H
    
    POP AX
    POP DX
    POP CX
    POP BX
    
    RET    
    
LINE ENDP    
    
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
    IMUL BX
    JMP @END
    
    @DIVISION:
    MOV AX, AX
    CWD
    IDIV BX
    
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

    END MAIN