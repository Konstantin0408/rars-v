##
# Initialization
##

.text
.globl reset, tib_init, boot
# board boot initializations
boot:
    li gp, 0x10301000
    PRINTSTR "INIT.\n"
    call interrupt_init 
    call uart_init      
    call gpio_init      

    
    li t0, RAM_BASE     
    li t1, HERE         
    sw t0, 0(t1)        

    
    la t0, SEMI    
    li t1, LATEST       
    sw t0, 0(t1)        
    
    la s6, extended     

# reset the Forth stack pointers, registers, variables, and state
reset:
    
    
    li sp, DSP_TOP
    la s1, interpreter_start    
    li s2, RSP_TOP              
    li s10, REAL_SP

    
    mv a0, zero         
    mv a1, zero         
    mv a2, zero         
    mv a3, zero         

    
    li t0, STATE        
    sw zero, 0(t0)      
    mv s8, zero

ALIGN_TO_CELL
# reset the RAM from the last defined word
ram_init:
    li t0, HERE         
    lw t0, 0(t0)        
    li t1, PAD          
ram_zerofill:
    
    beq t0, t1,ram_done 
    sw zero, 0(t0)      
    addi t0, t0, CELL   
    j ram_zerofill      
ram_done:
    

ALIGN_TO_CELL
# reset the terminal input buffer
tib_init:
    
    li t0, TIB          
    li t1, TOIN         
    li t2, TIB_TOP      
    sw zero, 0(t1)      
tib_zerofill:
    
    beq t2, t0,tib_done 
    addi t2, t2, -CELL  
    sw zero, 0(t2)      
    j tib_zerofill      
tib_done:
    j interpreter_start 

.data
msg_boot: .ascii "FiveForths v0.5, Copyright (c) 2021~ Alexander Williams, https://a1w.ca \n\n"
