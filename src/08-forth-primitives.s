##
# Forth primitives
##

.eqv NULL, 0

.text

# bye ( -- )           # Quit
defcode "bye", 0x018863c5, QUIT, NULL
    li a7, 10
    ecall

# reboot ( -- )         # Reboot the entire system and initialize memory
defcode "reboot", 0x06266b70, REBOOT, QUIT
    j err_reboot        

# @ ( addr -- x )       Fetch memory at addr
defcode "@", 0x0102b5e5, FETCH, REBOOT
    checkunderflow 0    
    lw t0, 0(sp)        
    lw t0, 0(t0)        
    sw t0, 0(sp)        
    NEXT

# ! ( x addr -- )       Store x at addr
defcode "!", 0x0102b5c6, STORE, FETCH
    checkunderflow CELL 
    lw t1, 0(sp)        
    lw t0, CELL(sp)     
    sw t0, 0(t1)        
    addi sp, sp, 8      
    NEXT

# sp@ ( -- addr )       Get current data stack pointer
defcode "sp@", 0x0388aac8, DSPFETCH, STORE
    PUSH sp             
    NEXT

# rp@ ( -- addr )       Get current return stack pointer
defcode "rp@", 0x0388a687, RSPFETCH, DSPFETCH
    PUSH s10            
    NEXT

# drop ( n -- )         Drop top value
defcode "drop", 0x0395d91a, DROP, RSPFETCH
    checkunderflow 0
    POP zero
    NEXT

# rot ( n1 n2 n3 -- n2 n3 n1 )         Drop top value
defcode "rot", 0x0388a69a, ROT, DROP
    checkunderflow 8
    POP t3
    POP t2
    POP t1
    PUSH t2
    PUSH t3
    PUSH t1
    
    NEXT

# 0= ( x -- f )         -1 if top of stack is 0, 0 otherwise
defcode "0=", 0x025970b2, ZEQU, ROT
    checkunderflow 0    
    lw t0, 0(sp)        
    snez t0, t0         
    addi t0, t0, -1     
    sw t0, 0(sp)        
    NEXT

# + ( x1 x2 -- n )      Add the two values at the top of the stack
defcode "+", 0x0102b5d0, SUM, ZEQU
    checkunderflow CELL 
    POP t0              
    lw t1, 0(sp)        
    add t0, t0, t1      
    sw t0, 0(sp)        
    NEXT

# * ( x1 x2 -- m )      Multiply the two values at the top of the stack
defcode "*", 0x0102b5cf, FMUL, SUM
    
    checkunderflow CELL 
    POP t0              
    lw t1, 0(sp)        
    mul t0, t0, t1      
    sw t0, 0(sp)        
    NEXT

# / ( x1 x2 -- n )      Divide the two values at the top of the stack
defcode "/", 0x0102b5d4, FDIV, FMUL
    
    checkunderflow CELL 
    POP t0              
    lw t1, 0(sp)        
    div t0, t1, t0      
    sw t0, 0(sp)        
    NEXT

# nand ( x1 x2 -- n )   Bitwise NAND the two values at the top of the stack
defcode "nand", 0x049b0c66, NAND, FDIV
    checkunderflow CELL 
    POP t0              
    lw t1, 0(sp)        
    and t0, t0, t1      
    not t0, t0          
    sw t0, 0(sp)        
    NEXT

# lit ( -- n )          Get the next word from IP and push it to the stack, increment IP
defcode "lit", 0x03888c4e, LIT, NAND
    lw t1, 0(s1)        
    PUSH t1             
    addi s1, s1, CELL   
    NEXT

# exit ( r:addr -- )    Resume execution at address at the top of the return stack
defcode "exit", 0x04967e3f, EXIT, LIT
    POPRSP s1           
    NEXT

##
# Forth I/O
##

# key ( -- x )          Read 8-bit character from uart input
defcode "key", 0x0388878e, KEY, EXIT
    li a7, 12
    ecall
    PUSH a0             
    NEXT

# emit ( x -- )         Write 8-bit character to uart output
defcode "emit", 0x04964f74, EMIT, KEY
    checkunderflow 0    
    
    
    POP a0              
    PUSHREG ra
    call uart_put       
    POP ra
    NEXT

# . ( x -- )            Write integer to uart output
defcode ".", 0x0402b5d3, DOT, EMIT
    checkunderflow 0    
    mv s5, ra
    li a0, CHAR_SPACE   
    call uart_put       
    POP a0              
    PRINTA0
    mv ra, s5
    NEXT

##
# Forth variables
##

# tib ( -- addr )       Store TIB variable address in top of data stack
defcode "tib", 0x0388ae44, FTIB, DOT
    li t1, TIB          
    PUSH t1
    NEXT

# state ( -- addr )     Store STATE variable address in top of data stack
defcode "state", 0x05614a06, FSTATE, FTIB
    li t1, STATE        
    PUSH t1
    NEXT

# >in ( -- addr )       Store TOIN variable address in top of data stack
defcode ">in", 0x0387c89a, FTOIN, FSTATE
    li t1, TOIN         
    PUSH t1
    NEXT

# here ( -- addr )      Store HERE variable address in top of data stack
defcode "here", 0x0497d3a9, FHERE, FTOIN
    li t1, HERE         
    PUSH t1
    NEXT

# latest ( -- addr )     Store LATEST variable address in top of data stack
defcode "latest", 0x06e8ca72, FLATEST, FHERE
    li t1, LATEST       
    PUSH t1
    NEXT

# begin                  Begin until loop, puts 
defcode "begin", 0x062587ea, BEGIN, FLATEST
    LOADINTO t2, SAVE_LINK_A1 
    li t1, 1
    PUSHCOND t1
    PUSHCOND t2
    NEXT

# until                 Begin until loop, puts 
defcode "until", 0x06828031, UNTIL, BEGIN
    POP t2
    
    bnez t2, until_reached
    lw t2, 0(s11)
    SAVETO t2, SAVE_LINK_A1
    NEXT
until_reached:
    POPCOND zero
    POPCOND zero
    NEXT

# if                     If - else - then
defcode "if", 0x06597834, IF, UNTIL
    POP t2
    li t1, 2
    PUSHCOND t1
    PUSHCOND t2
    NEXT

# else                   If - else - then
defcode "else", 0x06964c6e, ELSE, IF
    lw t2, 0(s11)
    seqz t2, t2
    sw t2, 0(s11)
    NEXT
    
# then                   If - else - then
defcode "then", 0x069e7354, THEN, ELSE
    POPCOND zero
    POPCOND zero
    NEXT

##
# Forth words
##

# : ( -- )              # Start the definition of a new word
defcode ":", 0x0102b5df, COLON, THEN
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
    
    mv s7, ra

    safecall djb2_hash      

    

    
    li t0, HERE
    li t1, LATEST
    la a2, .addr        

    
    lw t2, 0(t0)        
    lw t3, 0(t1)        

    
    
    li t5, PAD      
    bge t2, t5, err_mem 

    
    
    mv t0, t3           
    LOADINTO t3, HERE
    sw t3, 0(t1)        

    
    sw t0,       (t3)   
    sw a0,   CELL(t3)   
    addi t2, t2, 16
    sw t2,      8(t3)   
    li t0, 1
    sw t0,     12(t3)
    
    LOADINTO t4, HERE
    addi t4, t4, 16     
    SAVETO t4, HERE
    
    
    

    
    li t0, STATE        
    li t1, 1            
    sw t1, 0(t0)        
    li s8, 1
    
    mv ra, s7
    NEXT

docol:
    PUSHRSP s1          
    addi s1, a0, CELL   
    NEXT

.addr:
    j docol             

# ; ( -- )              # End the definition of a new word
defcode ";", 0x8102b5e0, SEMI, COLON
    
    PRINTSTR "ku-ku\n"
    
    li t0, HERE         
    lw t2, 0(t0)        

    sw zero, 0(t2)        

    addi t2, t2, CELL   
    sw t2, 0(t0)        

    
    li t0, STATE        
    sw zero, 0(t0)      
    li s8, 0
    NEXT

memory_error:
    li t2, LATEST       
    lw t2, 0(t2)        
    restorevars t2      
    j err_mem
