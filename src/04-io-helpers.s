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

.word 0

.text
.globl uart_print, uart_get, uart_put
uart_get:
    beqz s6, read_from_console
    lb a0, 0(s6)
    addi s6, s6, 1
    beqz a0, switch_to_console
    ret
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
    bnez s6, print_skip
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
