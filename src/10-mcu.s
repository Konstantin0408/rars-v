##
# GD32VF103
##

.data

ALIGN_TO_CELL
read_code: .space 2000
read_code_end: .word 0

.text

.globl uart_init, gpio_init

ALIGN_TO_CELL
# Initialize the UART
uart_init:
    la s9, read_code
    ret

ALIGN_TO_CELL
# Initialize the GPIO
gpio_init:
    
    ret
