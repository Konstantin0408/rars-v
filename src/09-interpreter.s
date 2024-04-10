##
# Interpreter
##

ALIGN_TO_CELL

.text
.globl interpreter_start

# here's where the program starts (the interpreter)
interpreter_start:
    
    MYDEBUG4 s11, " is cond top\n"
    
    li t2, TIB                                  
    li t3, TOIN                                 
    lw a1, 0(t3)                                
    add a1, a1, t2                              

interpreter:
    
    call uart_get                               
    li t4, CHAR_NEWLINE                         
    beq a0, t4, skip_send                       

    
    beqz a0, interpreter                        
    li t4, CHAR_CARRIAGE                        
    beq a0, t4, interpreter                     

    

skip_send:
    
    li t0, CHAR_COMMENT                         
    beq a0, t0, skip_comment                    

    li t0, CHAR_COMMENT_OPARENS                 
    beq a0, t0, skip_oparens                    


interpreter_tib:
    
    li t4, TIB_TOP                              
    bge a1, t4, err_tib                         
    sb a0, 0(a1)                                
    addi a1, a1, 1                              
    li t0, CHAR_NEWLINE                         
    beq a0, t0, replace_newline                 

    j interpreter                               

skip_comment:
    checkchar CHAR_NEWLINE, interpreter         
    j skip_comment                              

skip_oparens:
    checkchar CHAR_COMMENT_CPARENS, interpreter 
    j skip_oparens                              

ALIGN_TO_CELL
replace_newline:
    li a0, CHAR_SPACE       
    sb a0, -1(a1)           

process_token:
    
    li t2, TIB              
    li t3, TOIN             
    lw a0, 0(t3)            
    add a0, a0, t2          
    safecall token              

    
    li t2, TIB              
    add t0, a0, a1          
    sub t0, t0, t2          
    sw t0, 0(t3)            

    
    beqz a1, err_ok         
    
    li t0, 32               
    bgtu a1, t0, err_token  

    
    SAVETO a0, SAVE_A0
    SAVETO a1, SAVE_A1
    safecall number             
    bnez a1, lookup_word    
    bnez s8, define_number_push
    safecall push_number
    j process_token
    
define_number_push:        
    LOADINTO t1, HERE
    
    li t5, 1                
    sw t5,    0(t1)
    sw a0, CELL(t1)
    addi t1, t1, 8
    
    SAVETO t1, HERE
    j process_token        
    
lookup_word:
    
    
    LOADINTO a0, SAVE_A0
    LOADINTO a1, SAVE_A1
    
    safecall djb2_hash          
    
    
    

    li a1, LATEST           
    lw a1, 0(a1)            
    safecall lookup             
    
    
    lw t0, 4(a1)
    li t4, 0x00ffffff
    and t0, t0, t4
    
    
    
    
    
    addi a1, a1, 8          
    
    safecall process_block
    j process_token
    
process_block:

    
    
    
    
    LOADINTO t2, SAVE_LINK_A1
    MYDEBUG3 t2, " just test N0\n"
    
    lw t5, -4(a1)
    li t4, 0x00ffffff
    and t5, t5, t4
    
    
    
    mv t4, a1
    MYDEBUG4 t4, " is addr we have\n"
    
    LOADINTO t3, IF_ADDRESS
    beq t4, t3, skip_if_iet
    LOADINTO t3, ELSE_ADDRESS
    beq t4, t3, skip_if_iet
    LOADINTO t3, THEN_ADDRESS
    beq t4, t3, skip_if_iet
    
    li t4, 2
    lw t3, 4(s11)
    bne t3, t4, skip_if_iet
    lw t3, (s11)
    bnez t3, skip_if_iet
    
    ret
skip_if_iet:

    li t1, 0x0002b5e0
    mv t3, a1
    lw t2, 4(a1)
    
    lw a1, 0(a1)
    
    
    
    
    beq t5, t1, def_semi_skip 
    
    bnez s8, in_definition
    
    bnez t2, defined_word
    
def_semi_skip:
    PUSHR
    LOADINTO t2, SAVE_LINK_A1
    MYDEBUG3 t2, " just test N1\n"
    jalr a1
    LOADINTO t2, SAVE_LINK_A1
    MYDEBUG3 t2, " just test N2\n"
    POPR
    ret
    
in_definition:
    
    LOADINTO t1, HERE
    
    li t5, 2
    sw t5,    0(t1)
    sw t3, CELL(t1)
    addi t1, t1, 8
    
    SAVETO t1, HERE
    
    ret 
    
defined_word: 
    PUSHR
defined_loop:
    
    lw t0, 0(a1)
    beqz t0, defined_exit
    addi t0, t0, -1
    lw t1, CELL(a1)
    beqz t0, word_is_number
    
    PUSHR
    PUSHRFROM a1
    
    addi t2, a1, 8
    SAVETO t2, SAVE_LINK_A1
    
    mv a1, t1 
    
    
    call process_block
    POPRTO a1
    POPR
    addi a1, a1, 8
    LOADINTO t1, SAVE_LINK_A1
    beqz t1, defined_loop
    
    mv a1, t1
    j defined_loop
    
word_is_number:
    PUSH t1
    addi a1, a1, 8
    j defined_loop
defined_exit:
    SAVETO zero, SAVE_LINK_A1
    POPR
    ret 
    
    
#citwii
    

ALIGN_TO_CELL
execute:
    la s1, .loop            
    addi a0, a1, 8          
    lw t0, 0(a0)            
execute_done:
    jr t0                   

.data
.loop: .word .dloop         
.dloop: .word process_token 
.text

#compile

push_number:
    
    li t1, STATE            
    lw t1, 0(t1)            
    j push_stack            
    
    la t0, LIT              
    addi t0, t0, 8
    li t1, HERE             
    lw t2, 0(t1)            
    sw t0, 0(t2)            
    sw a0, 4(t2)            
    addi t0, t2, 8          
    sw t0, 0(t1)            
    ret                     
push_stack:
    PUSH a0                 
    
    ret                     
