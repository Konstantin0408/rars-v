##
# Internal functions
##

# compute a hash of a word
# arguments: a0 = buffer address, a1 = buffer size
# returns: a0 = 32-bit hash value
djb2_hash:
    li t0, 5381         
    li t1, 33           
    mv t3, a1           
    slli t3, t3, 24     
djb2_hash_loop:
    beqz a1, djb2_hash_done
    lbu t2, 0(a0)       
    mul t0, t0, t1      
    add t0, t0, t2      
    addi a0, a0, 1      
    addi a1, a1, -1     
    j djb2_hash_loop    
djb2_hash_done:
    li t4, 0x00ffffff
    and a0, t0, t4
    ret                 

# obtain a word (token) from the terminal input buffer
# arguments: a0 = buffer start address
# returns: a0 = token start address, a1 = token size (length in bytes)
token:
    li t1, CHAR_SPACE           
    mv t2, zero                 
token_char:
    lbu t0, 0(a0)               
    addi a0, a0, 1              
    beqz t0, token_zero         
    bgeu t1, t0, token_space    
    addi t2, t2, 1              
    j token_char                
token_space:
    beqz t2, token_char         
    addi a0, a0, -1             
    sub a0, a0, t2              
    j token_done
token_zero:
    addi a0, a0, -1             
token_done:
    mv a1, t2                   
    
    ret

# convert a string token to a 32-bit integer
# arguments: a0 = token buffer start address, a1 = token size (length in bytes)
# returns: a0 = integer value, a1 = 0 = OK, 1 or greater = ERROR
number:
    li t3, 0x27                 # apostrophe
    lbu t2, 0(a0)               
    bne t2, t3, number_numerical 
    lbu t2, 2(a0)               
    bne t2, t3, number_numerical 
    li t3, 3            
    bne a1, t3, number_numerical 
    
    lb a0, 1(a0)
    li a1, 0
    ret
    
    
number_numerical:
    li t1, 10                   
    mv t0, zero                 
    li t3, CHAR_MINUS           
    mv t4, zero                 
    lbu t2, 0(a0)               
    bne t2, t3, number_check    

    
    li t4, 1                    
    addi a0, a0, 1              
    addi a1, a1, -1             
    beqz a1, number_error       
number_check:
    
    li t3, 0x30                 # 0
    lbu t2, 0(a0)               
    bne t2, t3, number_digit    
    li t3, 0x78                 # x
    lbu t2, 1(a0)               
    bne t2, t3, number_digit   
    
    
    li t1, 16                   
    addi a0, a0, 2              
    addi a1, a1, -2             
    beqz a1, number_error       
number_digit:
    beqz a1, number_done        
    mul t0, t0, t1              
    lbu t2, 0(a0)        
    addi a0, a0, 1              

    
    sltiu t3, t2, 0x30          
    bnez t3, number_done        
    addi t2, t2, -0x30          
    sltiu t3, t2, 10            
    bnez t3, number_number   
    sltiu t3, t2, 0x31          # difference between numbers and lc letters
    bnez t3, number_done        
    addi t2, t2, -39          
number_number:
    slt t3, t2, t1              
    beqz t3, number_done        
    add t0, t0, t2              
    addi a1, a1, -1             
    bnez a1, number_digit       
number_done:
    beqz t4, number_store       
    neg t0, t0                  
number_store:
    
    mv a0, t0                   
    
    
    ret
number_error:
    li a1, 1                    
    ret

# search for a hash in the dictionary
# arguments: a0 = hash of the word, a1 = address of the LATEST word
# returns: a0 = hash of the word, a1 = address of the word if found
lookup:
    mv t2, a1                   
lookup_loop:
    beqz a1, lookup_error       
    lw t0, 4(a1)                

    li t4, 0x00ffffff
    and t0, t0, t4
    beq t0, a0, lookup_done     
lookup_next:
    lw a1, 0(a1)                
    j lookup_loop
lookup_error:
    
    li t0, STATE                
    lw t0, 0(t0)                
    
    li a0, CHAR_SPACE
    li a7, 11
    ecall
    
    LOADINTO a0, SAVE_A0
    LOADINTO a1, SAVE_A1
    add a2, a0, a1
    mv a1, a0
    call uart_print
    
    beqz t0, err_error          

    restorevars t2              
    j err_error                 
lookup_done:
    ret
