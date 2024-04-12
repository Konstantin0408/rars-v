##
# Macros
##

# align boundaries to 4 bytes
.eqv ALIGN_TO_CELL, .align 2

# set register to sum of two immediates
.macro SETSUM %reg, %im1, %im2
    li %reg, %im1
    addi %reg, %reg, %im2
.end_macro

# set register to difference between of two immediates
.macro SETDIF %reg, %im1, %im2
    li %reg, %im2
    sub %reg, zero, %reg
    li t3, %im1
    add %reg, %reg, t3
.end_macro

# jump to the next subroutine (ITC), appended to each primitive
.macro NEXT
    
    
    
    
    ret
.end_macro

# pop top of data stack to register and move DSP
.macro POP %reg
    lw %reg, 0(sp)      
    addi sp, sp, CELL   
.end_macro

# push register to top of stack and move DSP
.macro PUSH %reg
    SETSUM t0, RSP_TOP, CELL         
    blt sp, t0, err_overflow    

    sw %reg, -CELL(sp)  
    addi sp, sp, -CELL  
.end_macro

.macro PUSHREG %reg
    addi sp, sp, -4
    sw %reg, (sp)
.end_macro

# push register to return stack
.macro PUSHRSP %reg
    SETSUM t0, TIB_TOP, CELL         
    blt s2, t0, err_overflow    

    sw %reg, -CELL(s2)  
    addi s2, s2, -CELL  
.end_macro

# pop top of return stack to register
.macro POPRSP %reg
    li t0, RSP_TOP              
    bge s2, t0, err_underflow   

    lw %reg, 0(s2)      
    addi s2, s2, CELL   
.end_macro

# define a primitive dictionary word
.macro defcode %name, %hash, %label, %link
    .data
  string_address:
    .asciz %name
    ALIGN_TO_CELL
    .word 0 string_address
    .globl %label
  %label :
    .word %link        
    .globl hash_label
  hash_label :
    .word %hash        
    .globl code_label
  code_label :
    .word body_label   
    .globl body_label
  word_type:
    .word 0
    .text
  body_label :         
.end_macro

# check a character
.macro checkchar %char, %dest
    call uart_get       

    
    li t0, %char        
    beq a0, t0, %dest   
.end_macro

# print a message
.macro print_error %err_name, %msg_name, %size, %jump
    ALIGN_TO_CELL
    .globl %err_name
  %err_name :
    la a1, %msg_name    
    addi a2, a1, %size  
    call uart_print   
    j %jump             
.end_macro

# restore HERE and LATEST variables
.macro restorevars %reg
    
    #li t0, HERE         
    #sw %reg, 0(t0)      

    
    #li t0, LATEST       
    #lw t1, 0(%reg)      
    #sw t1, 0(t0)        
    
.end_macro

# check for stack underflow
.macro checkunderflow %stacktop
    SETDIF t0, DSP_TOP, %stacktop    
    bge sp, t0, err_underflow   
.end_macro

.macro READLABEL %label
    PUSH a0
    PUSH a1
    PUSH a7
    la a0, %label
    li a1, 500
    li a7, 8
    ecall
    POP a7
    POP a1
    POP a0
.end_macro

.macro debug_ecall
    
.end_macro

.macro TypeOnce %reg
    PUSHREG a0
    PUSHREG a1
    PUSHREG %reg
    mv a0, %reg
    li a7, 1
    ecall
    li a0, 0xa
    li a7, 11
    ecall
    POP %reg
    POP a1
    POP a0
.end_macro

.macro CharOnce %reg
    PUSHREG a0
    PUSHREG a1
    PUSHREG %reg
    mv a0, %reg
    li a7, 11
    ecall
    li a0, 0xa
    li a7, 11
    ecall
    POP %reg
    POP a1
    POP a0
.end_macro

.macro PRINTSTR %str
    .data
    mystr: .asciz %str
    .text
    
    PUSHRFROM a0
    PUSHRFROM a7
    la a0, mystr
    li a7, 4
    debug_ecall
    POPRTO a7
    POPRTO a0
.end_macro

.macro PRINTSTRWINFO %str
    .data
    mystr: .asciz %str
    .text
    
    PUSHRFROM a0
    PUSHRFROM a7
    la a0, mystr
    li a7, 4
    debug_ecall
    la a0, mystr
    li a7, 1
    debug_ecall
    PRINTSTR "\n"
    POPRTO a7
    POPRTO a0
.end_macro

.macro PRINTREG %reg
    PUSHRFROM a0
    PUSHRFROM a7
    mv a0, %reg
    li a7, 1
    debug_ecall
    POPRTO a7
    POPRTO a0
.end_macro

.macro PRINTREGLN %reg
    PUSHRFROM a0
    PUSHRFROM a7
    mv a0, %reg
    li a7, 1
    debug_ecall
    POPRTO a7
    POPRTO a0
.end_macro

.macro PRINTA0
    PUSHREG a7
    li a7, 1
    ecall
    POP a7
.end_macro

.macro PUSHR
  sw ra, -4(s10)  
  addi s10, s10, -CELL  
.end_macro

.macro POPR
  lw ra, 0(s10)  
  addi s10, s10, CELL  
.end_macro

.macro PUSHRFROM %reg
  sw %reg, -4(s10)  
  addi s10, s10, -CELL  
.end_macro

.macro POPRTO %reg
  lw %reg, 0(s10)  
  addi s10, s10, CELL  
.end_macro

.macro LOADINTO %reg %addr
  li %reg, %addr
  lw %reg, 0(%reg)
.end_macro

.macro SAVETO %reg %addr
  PUSHRFROM t0
  li t0, %addr
  sw %reg, 0(t0)
  POPRTO t0
.end_macro

.macro SAVE_TZERO %addr
  PUSHRFROM t1
  li t1, %addr
  sw t0, 0(t1)
  POPRTO t1
.end_macro

.macro safecall %label
  PUSHR
  call %label
  POPR
.end_macro

.macro myecall
  
.end_macro

.macro MYDEBUG %reg %str

    PUSHRFROM a0
    PUSHRFROM a7
    mv a0, %reg
    li a7, 1
    myecall
    POPRTO a7
    POPRTO a0
    
    .data
    mystr: .asciz %str
    .text
    
    PUSHRFROM a0
    PUSHRFROM a7
    la a0, mystr
    li a7, 4
    myecall
    POPRTO a7
    POPRTO a0
.end_macro

.macro MYDEBUG2 %reg %str

    PUSHRFROM a0
    PUSHRFROM a7
    mv a0, %reg
    li a7, 1
    myecall
    POPRTO a7
    POPRTO a0
    
    .data
    mystr: .asciz %str
    .text
    
    PUSHRFROM a0
    PUSHRFROM a7
    la a0, mystr
    li a7, 4
    myecall
    POPRTO a7
    POPRTO a0
.end_macro


.macro MYDEBUG3 %reg %str

    PUSHRFROM a0
    PUSHRFROM a7
    mv a0, %reg
    li a7, 1
    myecall
    POPRTO a7
    POPRTO a0
    
    .data
    mystr: .asciz %str
    .text
    
    PUSHRFROM a0
    PUSHRFROM a7
    la a0, mystr
    li a7, 4
    myecall
    POPRTO a7
    POPRTO a0
.end_macro

.macro MYDEBUG4 %reg %str

    PUSHRFROM a0
    PUSHRFROM a7
    mv a0, %reg
    li a7, 1
    myecall
    POPRTO a7
    POPRTO a0
    
    .data
    mystr: .asciz %str
    .text
    
    PUSHRFROM a0
    PUSHRFROM a7
    la a0, mystr
    li a7, 4
    myecall
    POPRTO a7
    POPRTO a0
.end_macro


.macro PUSHCOND %reg
  sw %reg, -4(s11)  
  addi s11, s11, -CELL  
.end_macro

.macro POPCOND %reg
  lw %reg, 0(s11)  
  addi s11, s11, CELL  
.end_macro
