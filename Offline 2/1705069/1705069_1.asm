.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
 
    A DB ?
    B DB ?
    C DB ?
    MSG DB CR, LF, 'All the numbers are equal$'
    MSG1 DB CR, LF, '2nd highest number: '
    ANS DB ?, '$'

.CODE
MAIN PROC
    ;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    ;Input
    MOV AH, 1
    INT 21H
    MOV A, AL
    
    MOV AH, 1
    INT 21H
    MOV B, AL
    
    MOV AH, 1
    INT 21H
    MOV C, AL
    
    
    ;Computation
    
    MOV AL, A
    CMP AL, B ;Compare A with B
    JG CASE1    ; if A > B
    JL CASE2    ; if A < B
    JE CASE3    ; if A = B

    CASE1: ;if A>B
        CMP AL, C ;Compare A with C
        JLE ANSA ;if A <= C
        
        MOV AL, B
        CMP AL, C ;Compare B with C
        JGE ANSB   ;if B >= C
            
        JMP ANSC ; else the answer is C
        
    CASE2: ;if A<B
        CMP AL, C ;Compare A with C
        JGE ANSA ; if A >= C
        
        MOV AL, C
        CMP AL, B ;Compare C with B
        JGE ANSB ; if C >= B
        
        
        
    CASE3: ;if A=B
        CMP AL, C
        JE NO_ANS
        JG ANSC
        JL ANSA
        
    
    
    ANSA:
    MOV AL, A
    MOV ANS, AL
    JMP DISPLAY
    
    ANSB:
    MOV AL, B
    MOV ANS, AL
    JMP DISPLAY
    
    ANSC:
    MOV AL, C
    MOV ANS, AL
    JMP DISPLAY
        
    NO_ANS:
    LEA DX, MSG
    MOV AH, 9
    INT 21H
    JMP END
    
    DISPLAY:
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    END:   
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H
    
    
MAIN ENDP
    END MAIN