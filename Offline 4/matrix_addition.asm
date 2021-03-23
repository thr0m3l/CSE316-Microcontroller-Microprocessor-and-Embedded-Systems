.MODEL SMALL
.STACK 100H

.DATA
CR DB 0DH
LF DB 0AH

SIZE DW 2
ROW DW 2
COL DW 2

MAT1 DW 2 DUP (?) 
     DW 2 DUP (?)

MAT2 DW 2 DUP (?)
     DW 2 DUP (?)

MSG1 DB 'first matrix :  $'
MSG2 DB 'second matrix : $'
MSG3 DB 'result: $'


.CODE
MAIN PROC 
    ;DS init
    MOV AX, @DATA
    MOV DS, AX
    
    
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    CALL LINE
    
       ;row index
    
    MOV DX, 1 ;which matrix to input
    CALL INMAT
    
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    
    CALL LINE
   
    MOV DX, 2
    CALL INMAT
        
    CALL LINE
    
    CALL ADDMAT ;matrix addition
    
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    
    CALL LINE
    
    CALL OUTMAT; ;output
    
    
    
    ;Exit
    MOV AH, 4CH
    INT 21H    
    
MAIN ENDP

;------------------------------

OUTMAT PROC
    ;outputs a matrix
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, ROW ;no of rows
    MOV SI, 0
    
    OUTPUT_ROW_:
        MOV BX, 0 ;col index
        
        OUTPUT_COL_:
            CMP BX, 4 ; colsize = col index?
            JE END_OUTPUT_COL_
            
            MOV AX, MAT1[SI+BX]
            CALL OUTDEC
            
            MOV DL, ' '
            MOV AH, 2
            INT 21H
            
            ADD BX, 2
            JMP OUTPUT_COL_
        END_OUTPUT_COL_:
        
        ADD SI, 4
        
        CALL LINE  
        
        LOOP OUTPUT_ROW_
    
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET 
    
    
    
OUTMAT ENDP

;-------------------------------

ADDMAT PROC
    
    ;performs matrix addition
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, ROW ;no of rows
    MOV SI, 0
    
    ROW_:
        MOV BX, 0 ;col index
        
        COL_:
            MOV AX, COL
            IMUL SIZE
            CMP BX, AX ; colsize = col index?
            JE END_COL_ ; if equal, done with the row
            
            MOV AX, MAT1[SI+BX]
            ADD AX, MAT2[SI+BX]
            MOV MAT1[SI+BX], AX
            
            ADD BX, 2
            CALL LINE
            JMP COL_
        END_COL_:
        
        ADD SI, 4  
        
        LOOP ROW_
    
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET 
   
    
ADDMAT ENDP

INMAT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, ROW ;no of rows
    MOV SI, 0
    
    INPUT_ROW_:
        MOV BX, 0 ;col index
        
        INPUT_COL_:
            MOV AX, 4
            CMP BX, AX ; colsize = col index?
            JE END_INPUT_COL_
            CALL INDEC
            
            CMP DX, 2
            JE @MAT2
      
            @MAT1:
            MOV MAT1[SI+BX], AX
            JMP @NEXT:
            @MAT2:
            MOV MAT2[SI+BX], AX
            @NEXT:
            ADD BX, 2
            CALL LINE
            JMP INPUT_COL_
        END_INPUT_COL_:
        
        ADD SI, 4  
        
        LOOP INPUT_ROW_
    
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET    
  
INMAT ENDP



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

END MAIN