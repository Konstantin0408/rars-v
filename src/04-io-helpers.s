##
# I/O Helpers
##

.data

extended:
.ascii ": - ( n1 n2 -- n ) -1 * + ;\n"
.ascii ": dup ( n1 -- n1 n1 ) sp@ @ ;\n"
.ascii ": over ( n1 n2 -- n1 n2 n1 ) sp@ 4 + @ ;\n"
.ascii ": swap ( n1 n2 -- n2 n1 ) over rot drop ;\n"
.ascii ": allot ( n -- ) here @ + here ! ;\n"
.ascii ": = ( n1 n2 -- b ) - 0= ;\n"
.ascii ": mod ( n1 n2 -- m ) over over / * - ;\n"
.ascii ": invert ( n1 -- ~n1 ) dup nand ;\n"
.ascii ": and ( n1 n2 -- n ) nand invert ;\n"
.ascii ": or ( n1 n2 -- n ) invert swap invert nand ;\n"
.ascii ": nor ( n1 n2 -- n ) ( n1 n2 -- n ) or invert ;\n"
.ascii ": xor ( n1 n2 -- n )  over over or rot rot nand and ;\n"
.ascii ": xnor ( n1 n2 -- n ) xor invert ;\n"
.ascii ": negative ( n -- b ) 0x80000000 and 0x80000000 = ;\n"
.ascii ": positive ( n -- b ) invert negative ; \n"
.ascii ": < ( n1 n2 -- b ) over over xor negative if drop else - then negative ;\n"
.ascii ": > ( n1 n2 -- b ) swap < ;\n"

.word 0

file_buffer: .space 16000
.word 0



.text
.globl uart_print, uart_get, uart_put
uart_get:
    beqz s6, read_from_console
    lb a0, 0(s6)
    li t0, 13
    addi s6, s6, 1
    beq a0, t0, uart_get
    beqz a0, switch_to_console_or_file
    ret
switch_to_console_or_file:
    LOADINTO t0, ARG_COUNT
    LOADINTO t1, CURRENT_ARG
    addi t1, t1, 1
    SAVETO t1, CURRENT_ARG
    
    beqz t0, switch_to_console
    
    
    LOADINTO t3, CURR_FILEDSC
    # todo close file
    
    bne t0, t1, read_from_file
    li a7, 10
    ecall

read_from_file:
    LOADINTO t1, CURRENT_ARG
    slli t1, t1, 2                # t1 is arg number and is multiplied by 4
    LOADINTO t2, ARGS
    add t1, t2, t1
    
    lw a0, (t1)
    
    li a1, 0
    li a7, 1024
    ecall
    # now a0 has file descriptor
    la a1, file_buffer
    li a2, 4000
    li a7, 63
    
    la s6, file_buffer
    
    
    ecall
    
    la a0, file_buffer
    li a1, TIB
    
    j uart_get

switch_to_console:
    mv s6, zero
read_from_console:
    la t0, read_code
    bne s9, t0, skip_readline
    READLABEL read_code
skip_readline:
    lb a0, (s9)
    addi s9, s9, 1
    
    li t1, CHAR_NEWLINE
    bne a0, t1, skip_line_reset
    la s9, read_code
skip_line_reset:
    ret


uart_put:
    LOADINTO t2, CURRENT_ARG
    li t1, -1
    beq t2, t1, print_skip
    PUSH a7
    li a7, 11
    ecall
    POP a7
print_skip:
    ret

# print a string to the uart
# arguments: a1 = address of the message to be printed, a2 = address+length of the message
uart_print:
    mv s3, ra                   
uart_print_loop:
    beq a1, a2, uart_print_done 
    lbu a0, 0(a1)               
    call uart_put
    addi a1, a1, 1              
    j uart_print_loop           
uart_print_done:
    mv ra, s3                   
    ret
