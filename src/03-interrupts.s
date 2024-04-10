##
# Interrupts
##

ALIGN_TO_CELL
.globl interrupt_handler, interrupt_init
interrupt_handler:
    uret

# Initialize the interrupt CSRs
interrupt_init:
    
    csrci ustatus, 0x08  

    
    csrs zero, uie      

    
    la t0, interrupt_handler
    csrw t0, utvec      

    ret
